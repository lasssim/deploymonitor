require 'spec_helper'

module Dockerize

  describe Sender do
    let(:sender_hash) do
      JSON.parse(GithubHooks.sender_json)
    end

    subject do
      described_class.new(sender_hash)
    end

    its(:name) { is_expected.to eq "lister" }
  end

end
