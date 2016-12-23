require 'spec_helper'

module UseCase
  describe UpdateContainer do
    subject do
      described_class.new(
        GithubHooks::master_lister(
          pusher: pusher,
          full_name: full_name
        ),
        logger: logger
      )
    end
    let(:logger) { nil }
    let(:pusher) { "lister" }
    let(:full_name) { "lister/docker-hello-world" }

    let(:dockerizer) { subject.dockerizer }

    before do
      allow_any_instance_of(Dockerize::Repository).to receive(:clone_url) {
        "spec/fixtures/docker-hello-world.git"
      }
    end


    after do
      if (dockerizer.state rescue nil) == "running"
        dockerizer.stop
        dockerizer.remove
      end

      subject.worker.clean_up
    end

 
    context "pusher filter" do
      context "valid pusher", :wip do
        it "doesn't raise an error" do
          expect {
            subject.run
          }.to_not raise_error
        end
      end

      context "invalid pusher" do
        let(:pusher) { "wrong" }
        it "raises an ArgumentError" do
          expect {
            subject.run
          }.to raise_error ArgumentError
        end
      end
    end

    context "repository filter" do
      context "valid full_name" do
        it "doesn't raise an error" do
          expect {
            subject.run
          }.to_not raise_error
        end
      end

      context "invalid full_name" do
        let(:full_name) { "wrong" }
        it "raises an ArgumentError" do
          expect {
            subject.run
          }.to raise_error ArgumentError
        end
      end

    end

    context "container" do

      let(:container_name) do
        subject.repository.name.split("/").last
      end

      context "new" do
        it "has no container running" do
          expect {
            Docker::Container.get(container_name)
          }.to raise_error(Docker::Error::NotFoundError)
        end

        it "starts a new container" do
          expect {
            subject.run
          }.to change {
            all = Docker::Container.all(all: true)
            all.size
          }.by(1)
        end
      end

      context "update" do
        before do
          subject.run
        end

        it "has one container running" do
          expect(
            Docker::Container.get(container_name)
          ).to be_a Docker::Container
        end

        it "updates the container", :wip do
          expect {
            subject.worker.work do 
              File.open("VERSION", 'w') { |file| file.write("1.0.0") }
            end
            described_class.new(
              GithubHooks::master_lister(
                pusher: pusher,
                full_name: full_name
              ),
              logger: logger
            ).run
          }.to change {
            Docker::Container.get(container_name).info["Image"]
          }
        end
      end

    end

  end
end
