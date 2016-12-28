require 'spec_helper'


describe App, :wip do

  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
	end

  let(:sender) { "lister" }
  let(:full_name) { "lister/docker-hello-world" }

  let(:logger) { nil }

  let(:body) do
    GithubHooks::master_lister(
      sender: sender,
      full_name: full_name
    )
  end

  let(:container_name) do
    full_name.split("/").last
  end


  before do
    allow_any_instance_of(Dockerize::Repository).to receive(:clone_url) {
      "spec/fixtures/docker-hello-world.git"
    }

    allow_any_instance_of(Dockerize::Dockerizer).to receive(:logger) { nil }
    allow_any_instance_of(Dockerize::Worker).to receive(:logger) { nil }
  end


  after do
    Dockerize::Dockerizer.clean_all(container_name)
  end


  context "new" do
    it "has no container running" do
      expect {
        Docker::Container.get(container_name)
      }.to raise_error(Docker::Error::NotFoundError)
    end

    it "starts a new container" do
      expect {
        post '/', body, {'CONTENT_TYPE' => 'application/json'}
      }.to change {
        all = Docker::Container.all(all: true)
        all.size
      }.by(1)
    end
  end

  context "update" do
    before do
      post '/', body, {'CONTENT_TYPE' => 'application/json'}
    end

    let(:worker) do
      hash = JSON.parse(GithubHooks.repository_json)
      repository = Dockerize::Repository.new(hash)
      Dockerize::Worker.new(repository: repository, logger: logger)
    end



    it "has one container running" do
      expect(
        Docker::Container.get(container_name)
      ).to be_a Docker::Container
    end

    it "updates the container", :wip do
      expect {
        worker.work do 
          File.open("VERSION", 'w') { |file| file.write("1.0.0") }
        end
        
        post '/', body, {'CONTENT_TYPE' => 'application/json'}
      }.to change {
        Docker::Container.get(container_name).info["Image"]
      }
    end
  end

end
