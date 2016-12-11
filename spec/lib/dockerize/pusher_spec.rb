require 'spec_helper'

module Dockerize

  describe Pusher do
    let(:pusher_hash) do
      JSON.parse(GithubHooks.pusher_json)
    end

    subject do
      described_class.new(pusher_hash)
    end

    its(:name) { is_expected.to eq "lister" }
  end

end
