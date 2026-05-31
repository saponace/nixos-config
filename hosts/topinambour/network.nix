{ ... }:
{
  networking = {
    hostName = "topinambour";
    networkmanager.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
    # Publish "stak.local" as a CNAME alias so other configs can use it without knowing the real hostname
    extraServiceFiles.stak = ''
      <?xml version="1.0" standalone='no'?>
      <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
      <service-group>
        <name>stak</name>
        <service>
          <type>_device-info._tcp</type>
          <port>0</port>
        </service>
        <host-name>stak.local</host-name>
      </service-group>
    '';
  };
}
