define golang::tarball (
  $version,
  $os,
  $arch,
  $install_root,
  $download_mirror
) {
  $filename = "go$version.$os-$arch.tar.gz"
  $url = "$download_mirror/$filename"

  Exec {
    path => '/bin:/usr/bin:/usr/local/bin',
  }

  exec {"download-go-tarball-$title":
    command => "curl -o $filename $url",
    cwd => "$install_root",
    unless => "ls -d $install_root/go",
  }

  ~> exec {"unpack-go-tarball-$title":
    command => "tar xzf $filename",
    cwd => "$install_root",
    refreshonly => true,
  }

  ~> exec {"remove-go-tarball-$title":
    command => "rm $filename",
    cwd => "$install_root",
    refreshonly => true,
  }

  -> file {"/etc/profile.d/99go-$version.sh":
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => 0644,
    content => "export PATH=\"$install_root/go/bin:\$PATH\"
export GOROOT=\"$install_root/go\"",
  }
}
