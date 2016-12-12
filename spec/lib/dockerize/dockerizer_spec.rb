require 'spec_helper'

module Dockerize
  describe Dockerizer do

    after do
      worker.clean_up
    end

    after do
      described_class.clean_all("lister/docker-hello-world")
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

    context "3 images" do
      let(:versions) { ["1.0.0", "2.0.2", "0.0.1"] }
      let!(:images) do
        versions.map do |version|
          worker.work do 
            File.open("VERSION", 'w') { |file| file.write(version) }
          end
          Dockerizer.new(worker: worker, logger: logger).image
        end
      end

      context "images" do

        it "returns the correct amount of images" do
          expect(subject.images.size).to eq versions.size
        end

        it "sorts correctly", :wip do
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
      after { subject.clean_up }
      it "creates a docker image", :wip do
        expect {
          subject.image
        }.to change { 
          subject.images.size
        }.by(1)
      end

      it "is findable by name" do
      end

      context "tag" do
        
        context "version" do
          pending
        end


        context "latest" do
          pending
        end
      end
    end
  end
end
