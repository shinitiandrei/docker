require 'spec_helper'

describe 'docker_test::service_execute' do
	cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

	before do
		stub_command("[ ! -z `docker ps -qaf 'name=busybox_ls$'` ]").and_return(false)
		stub_command("[ ! -z `docker ps -qaf 'name=bill$'` ]").and_return(false)
		stub_command("[ ! -z `docker ps -qaf 'name=hammer_time$'` ]").and_return(false)
		stub_command('docker ps -a | grep red_light | grep Exited').and_return(true)
		stub_command("[ ! -z `docker ps -qaf 'name=red_light$'` ]").and_return(false)
		stub_command("[ ! -z `docker ps -qaf 'name=green_light$'` ]").and_return(false)
		stub_command("[ ! -z `docker ps -qaf 'name=quitter$'` ]").and_return(false)
		stub_command("[ ! -z `docker ps -qaf 'name=restarter$'` ]").and_return(false)
		stub_command("[ ! -z `docker ps -qaf 'name=uber_options$'` ]").and_return(false)
		stub_command("[ ! -z `docker ps -qaf 'name=kill_after$'` ]").and_return(false)
		stub_command("[ ! -z `docker ps -qaf 'name=change_network_mode$'` ]").and_return(false)
	end

  context 'testing enable action' do
    it 'enable docker in suse' do
      expect(chef_run).to enable_docker_service('suse')
    end

    it 'testing install docker binary' do
      expect(chef_run).to create_docker_installation_binary('default')
    end

    it 'testing start docker manager' do
      expect(chef_run).to start_docker_service_manager_execute('default')
    end
  end
end
