require 'spec_helper'

describe 'scaleio::cluster' do

  let (:title) {'title'}
  let (:default_params) {{ :ensure => 'present' }}

  it { is_expected.to contain_scaleio__cluster(title) }
  context 'when cluster_mode is defined' do

    let :params do
      default_params.merge({ :cluster_mode => '1' })
    end
    it 'switches cluster mode' do
      is_expected.to contain_scaleio__cmd('switch cluster mode present').with(
        :action => 'switch_cluster_mode',
        :ref => 'cluster_mode',
        :value => '1_node',
        :extra_opts => "--add_slave_mdm_name  --add_tb_name  --i_am_sure",
        :unless_query => 'query_cluster | grep -A 1 "Cluster:" | grep')
    end
    it { is_expected.to contain_exec('scli  --approve_certificate --switch_cluster_mode --cluster_mode 1_node   --add_slave_mdm_name  --add_tb_name  --i_am_sure').with(
      :command => 'scli  --approve_certificate --switch_cluster_mode --cluster_mode 1_node   --add_slave_mdm_name  --add_tb_name  --i_am_sure',
      :path => ['/bin/'],
      :unless => 'scli  --approve_certificate --query_cluster | grep -A 1 "Cluster:" | grep 1_node ')}
    it { is_expected.to contain_notify('SCLI COMMAND: scli  --approve_certificate --switch_cluster_mode --cluster_mode 1_node   --add_slave_mdm_name  --add_tb_name  --i_am_sure')}
    it { is_expected.to contain_notify('SCLI UNLESS: scli  --approve_certificate --query_cluster | grep -A 1 "Cluster:" | grep 1_node ')}

    context 'when ensure is absent' do
      let :params do
        default_params.merge({ :ensure => 'absent', :cluster_mode => '1' })
      end
      it 'switchs cluster mode' do
        is_expected.to contain_scaleio__cmd('switch cluster mode absent').with(
          :action => 'switch_cluster_mode',
          :ref => 'cluster_mode', 
          :value => '1_node',
          :extra_opts => "--remove_slave_mdm_name  --remove_tb_name  --i_am_sure",
          :unless_query => 'query_cluster | grep -A 1 "Cluster:" | grep')
      end
      it { is_expected.to contain_exec('scli  --approve_certificate --switch_cluster_mode --cluster_mode 1_node   --remove_slave_mdm_name  --remove_tb_name  --i_am_sure').with(
        :command => 'scli  --approve_certificate --switch_cluster_mode --cluster_mode 1_node   --remove_slave_mdm_name  --remove_tb_name  --i_am_sure',
        :path => ['/bin/'],
        :unless => 'scli  --approve_certificate --query_cluster | grep -A 1 "Cluster:" | grep 1_node ')}
      it { is_expected.to contain_notify('SCLI COMMAND: scli  --approve_certificate --switch_cluster_mode --cluster_mode 1_node   --remove_slave_mdm_name  --remove_tb_name  --i_am_sure')}   
      it { is_expected.to contain_notify('SCLI UNLESS: scli  --approve_certificate --query_cluster | grep -A 1 "Cluster:" | grep 1_node ')}
    end
  end
  context 'when cluster_mode is undefined' do
    let :params do
      default_params.merge({ :cluster_mode => '' })
    end
    it { is_expected.not_to contain_scaleio__cmd('switch cluster mode')}
  end
  context 'when new_password is defined' do
    let :params do
      default_params.merge({ :new_password => 'new_password' })
    end
    it 'sets password' do
      is_expected.to contain_scaleio__cmd('set password').with(
        :action => 'set_password',
        :ref => 'new_password',
        :value => 'new_password',
        :scope_ref => 'old_password', 
        :scope_value => nil,
        :approve_certificate => '')
    end
    it { is_expected.to contain_exec('scli   --set_password --new_password new_password   ').with(
      :command => 'scli   --set_password --new_password new_password   ',
      :path => ['/bin/'],)}
    it { is_expected.to contain_notify('SCLI COMMAND: scli   --set_password --new_password new_password   ')}
  end
  context 'when new_password isnt defined' do
    let :params do
     default_params.merge({ :new_password => nil })
    end
    it { is_expected.not_to contain_scaleio__cmd('set password')}
  end
  context 'when exists license_file_path' do
    let :params do
      default_params.merge({ :license_file_path => '/tmp/foo' })
    end
    it 'sets license' do
      is_expected.to contain_scaleio__cmd('set license').with(
        :action => 'set_license',
        :ref => 'license_file',
        :value => '/tmp/foo')
    end
    it { is_expected.to contain_exec('scli  --approve_certificate --set_license --license_file /tmp/foo   ').with(
      :command => 'scli  --approve_certificate --set_license --license_file /tmp/foo   ',
      :path => ['/bin/'],)}
    it { is_expected.to contain_notify('SCLI COMMAND: scli  --approve_certificate --set_license --license_file /tmp/foo   ')}
  end
  context 'when license_file_path doesnt exist' do
    let :params do
      default_params.merge({ :license_file_path => nil })
    end
    it { is_expected.not_to contain_scaleio__cmd('set license')}
  end
end
