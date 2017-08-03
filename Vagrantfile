Vagrant.configure('2') do |config|
  config.vm.box = 'bento/centos-7.3'
  # Disable the default synced folder because it's too much trouble to set up
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider 'virtualbox' do |vb|
    # Want this on to work on bootloader stuff
    vb.gui = true
  end

  config.vm.network :private_network, ip: '10.0.0.10'
  config.vm.hostname = 'rhcse-study-vm-1'
end
