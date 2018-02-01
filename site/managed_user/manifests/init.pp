class managed_user {

  managed_user::managed_user { 'joe':}
  
  managed_user::managed_user { 'alice':
    group => 'root',
  }

}