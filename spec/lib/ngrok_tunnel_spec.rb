require 'spec_helper'

describe NgrokTunnel do

  let(:config) do
    { 
      "app_port" => app_port, 
      "repositories" => repositories 
    } 
  end
  
  let(:repositories) do 
    [
      { 
        "name" => "lister/docker-hello-world", 
        "github_hook_id" => "11325330" 
      }
    ]
  end

  let(:app_port) { 8080 }

  before do 
    NgrokTunnel.configure(config)
  end

  context "setup" do
    after { NgrokTunnel.setup }

    context "app_port" do
      before { allow(NgrokTunnel.github_client).to receive(:edit_hook) }
      context "8080" do
        it "starts the tunnel at the configured port" do
          expect(Ngrok::Tunnel).to receive(:start).with(port: app_port)
        end
      end

      context "9999" do
        let(:app_port) { 9999 }
        it "starts the tunnel at the configured port" do
          expect(Ngrok::Tunnel).to receive(:start).with(port: app_port)
        end

      end
      
    end

    context "edit hook" do
      before do 
        allow(Ngrok::Tunnel).to receive(:start) 
        allow(Ngrok::Tunnel).to receive(:ngrok_url).and_return("http://example.com") 
      end

      context "no repository" do
        let(:repositories) { [] }

        it "doesn't get called" do
          expect(NgrokTunnel.github_client).to_not receive(:edit_hook)
        end
      end


      context "one repository" do
        let(:repositories) do
          [
            { 
              "name" => "lister/docker-hello-world", 
              "github_hook_id" => "11325330" 
            }
          ]
        end

        it "gets called with the right arguments" do
          expect(NgrokTunnel.github_client).to receive(:edit_hook).with(
            "lister/docker-hello-world",
            "11325330",
            "web",
            { url: kind_of(String), content_type: "json" }
          ).once
        end

      end


      context "two repositories" do
        let(:repositories) do
          [
            { 
              "name" => "lister/docker-hello-world", 
              "github_hook_id" => "11325330" 
            },
            { 
              "name" => "lister/docker-hello-world2", 
              "github_hook_id" => "2" 
            }
          ]
        end

        it "gets called with the right arguments" do
          expect(NgrokTunnel.github_client).to receive(:edit_hook).with(
            "lister/docker-hello-world",
            "11325330",
            "web",
            { url: kind_of(String), content_type: "json" }
          ).once
          expect(NgrokTunnel.github_client).to receive(:edit_hook).with(
            "lister/docker-hello-world2",
            "2",
            "web",
            { url: kind_of(String), content_type: "json" }
          ).once
        end
      end
    end
  end



end
