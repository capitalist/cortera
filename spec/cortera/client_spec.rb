require 'helper'

describe Cortera::Client do
  describe '.new' do # {{{1
    context 'when no credentials are provided' do # {{{2
      it 'does not raise an exception' do
        expect { Cortera::Client.new }.not_to raise_error
      end
    end

    context 'when credentials are provided via options hash' do # {{{2
      before { @client = Cortera::Client.new username: 'foo', password: 'bar' }

      it 'saves the credentials' do
        expect(@client.username).to eq 'foo'
      end
    end

    context 'when credentials are provided via config block' do # {{{2
      before do
        @client = Cortera::Client.new do |config|
          config.username = 'foo'
          config.password = 'bar'
        end
      end

      it 'saves the credentials' do
        expect(@client.username).to eq 'foo'
      end
    end
  end

  describe '#connection' do # {{{1
    before { @client = Cortera::Client.new username: 'foo', password: 'bar' }
    it 'looks like Faraday connection' do
      expect(@client.send(:connection)).to respond_to(:run_request)
    end
    it 'memoizes the connection' do
      c1, c2 = @client.send(:connection), @client.send(:connection)
      expect(c1.object_id).to eq(c2.object_id)
    end
  end

  describe '#connection_options' do #{{{1
    before { @client = Cortera::Client.new username: 'foo', password: 'bar' }
    it 'returns the connection options hash with accept and user agent' do
      expect(@client.connection_options[:headers][:accept]).to eql('application/json')
      expect(@client.connection_options[:headers][:user_agent]).to match(/Cortera Ruby Client/)
    end
  end

  describe '#business_risk' do #{{{1
    before { @client = Cortera::Client.new }
    let(:company_name) { 'Publix' }
    let(:city) { 'Lakeland' }
    let(:state) { 'FL' }

    it 'returns' do
      expect(@client.cpr_report(name: company_name, city: city, state: state).body).to eq(1)
    end
  end
end

# vim: set fdm=marker:
