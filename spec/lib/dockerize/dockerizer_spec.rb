require 'spec_helper'

module Dockerize
  describe Dockerizer do

    after do
      worker.clean_up
    end

    after do
      described_class.clean_all("lister/docker-hello-world")
    end

    before do
      allow_any_instance_of(Repository).to receive(:clone_url) {
        "spec/fixtures/docker-hello-world.git"
      }
    end




    let(:worker) do
      hash = JSON.parse(GithubHooks.repository_json)
      repository = Repository.new(hash)
      Worker.new(repository: repository, logger: logger)
    end

    let(:logger) do
      Logger.new(STDOUT)
      nil
    end
    
    subject do
      described_class.new(worker: worker, logger: logger, keep_nr_images: 2)
    end

    its(:worker)     { is_expected.to eq worker }
    its(:docker_url) { is_expected.to eq "unix:///var/run/docker.sock" }

    def create_version(worker, version)
      worker.work do 
        File.open("VERSION", 'w') { |file| file.write(version) }
      end
      Dockerizer.new(worker: worker, logger: logger).image
    end

    context "3 images" do
      let(:versions) { ["1.0.0", "2.0.2", "0.0.1"] }
      let!(:images) do
        versions.map do |version|
          create_version(worker, version)
        end
      end

      context "images" do

        it "returns the correct amount of images" do
          expect(subject.images.size).to eq versions.size
        end

        it "sorts correctly" do
          tags = subject.images.map do |image|
            image.info["RepoTags"]
          end

          expect(tags).to contain_exactly(
            ["lister/docker-hello-world:1.0.0"],
            ["lister/docker-hello-world:2.0.2"],
            match_array(["lister/docker-hello-world:latest", "lister/docker-hello-world:0.0.1"])
          )
        end
      end

      context "clean_up" do
        it "changes the amount of images by the correct amount" do
          subject.clean_up
          expect(subject.images.size).to eq subject.keep_nr_images
        end
      end

    end


    context "image" do
      it "creates a docker image" do
        expect {
          subject.image
        }.to change { 
          subject.images.size
        }.by(1)
      end

      it "finds the latest image" do
        subject.image
        expect(subject.latest_image).to be_a Docker::Image
      end

    end

    context "start" do
      before do
        subject.image
      end

      after do
        subject.stop
        subject.remove
      end

      let(:container_name) do
        subject.worker.repository.name.split("/").last
      end

      context "none running" do
        it "has no container running" do
          expect {
            Docker::Container.get(container_name)
          }.to raise_error(Docker::Error::NotFoundError)
        end

        it "starts a new container" do
          expect {
            subject.start
          }.to change {
            Docker::Container.all(all: true).size
          }.by(1)
        end
      end

      context "old version running" do
        before do
          subject.start
        end

        let(:new_image) do
          create_version(subject.worker, "2.2.2")
        end

        it "has started one container" do
          expect(Docker::Container.get(container_name)).to be_a Docker::Container 
        end

        it "has one container running" do
          expect(subject.state).to eq "running"
        end

        it "starts a new version" do
          expect {
            new_image
            subject.stop
            subject.remove
            subject.start
          }.to change {
            subject.send(:container).info["ImageID"]
          }
        end

      end

    end
  end
end
