define golang (
  $version,
  $install_root = "/opt",
  $download_mirror = 'http://go.googlecode.com/files'
) {
  $os = $kernel ? {
    'Linux' => 'linux',
    'Darwin' => 'darwin',
    'FreeBSD' => 'freebsd',
    'Windows' => 'windows',
    default => undef,
  }

  if $os == undef {
    error "Unsupported kernel type $kernel"
  }

  $arch = $architecture ? {
    /^(i386|x86)$/ => '386',
    /^(x86_64|amd64)$/ => 'amd64',
    default => undef,
  }

  if $arch == undef {
    error "Unsupported architecture $kernel"
  }

  golang::tarball {"golang-tarball-$title":
    version => $version,
    os => $os,
    arch => $arch,
    install_root => $install_root,
    download_mirror => $download_mirror,
  }

  # Potentially add other install methods here
}
