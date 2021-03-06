require 'spec_helper'

DOCKER_IMAGE_DIRECTORY = File.dirname(File.dirname(__FILE__))

describe 'Dockerfile' do
  include Vtasks::Utils::DockerSharedContext::RunningCommandContainer

  it 'uses the correct OS' do
    expect(os[:family]).to eq('alpine')
  end

  describe file('/sbin/tini') do
    it { is_expected.to exist }
    it { is_expected.to be_executable }
  end

  packages = %w(curl tini)
  packages.each do |pkg|
    describe package(pkg) do
      it { is_expected.to be_installed }
    end
  end

  describe command('curl --version') do
    its(:stdout) { is_expected.to contain('curl') }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe file('/usr/local/bin/gunicorn') do
    it { should exist }
    it { should be_executable }
  end

  describe command('/usr/local/bin/gunicorn --version') do
    its(:stderr) { is_expected.to contain('gunicorn') }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe file('/usr/local/bin/pip') do
    it { should exist }
    it { should be_executable }
  end

  describe command('/sbin/tini -h') do
    its(:stdout) { is_expected.to contain('tini') }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
