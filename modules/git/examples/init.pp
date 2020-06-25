node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'git':
    sources_manage => true,
    users          => {
      'user' => {},
      'root' => {},
    },
    require        => Notify['enduser-before'],
    before         => Notify['enduser-after'],
  }
}
