define git::repo (
  $path = $title,
  $owner = 'root',
  $group = 'root',
  $clonesource = '',
  $pullsource = '',
)
{
  require git

  $gitbin = '/usr/bin/git'

  if $clonesource {
    if ! defined(File[$path]) {
      $createrepo = "${gitbin} clone ${clonesource} ${path}"
      $creates = $path
      $timeout = 0
    }
    else {
      fail('The clone destiny directory ${path} already exists.')
    }
  }
  elsif $pullsource {
    if defined(File[$path]) {
      $createrepo ="cd ${path} && ${gitbin} pull --rebase"
    }
    else {
      fail("The repo directory ${path} does not exist. Cannot pull from ${pullsource}.")
    }
  }
  else {
    if ! defined(File[$path]) {
      file { $path:
        ensure => directory,
      }
    }
    $createrepo = "${gitbin} init --target ${path}"
    $creates = $path
  }

  exec { $createrepo:
    user    => $owner,
    group   => $group,
    creates => $creates,
    timeout => $timeout,
  }
}
