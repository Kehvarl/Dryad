<?php
class uPost
{
  public $tag;
  public $username;
  public $message;
  public $time;
  public $ip;

  public function __construct($username, $message, $tag="")
  {
    $this->tag = $tag;
    $this->username = $username;
    $this->message = $message;
    $this->time = date(DATE_W3C, time());
    $this->ip = $_SERVER['REMOTE_ADDR'];
  }

  public function toArray($isAdmin = false)
  {
    $ret = array(
      "tag"	=>$this->tag,
      "user"	=>$this->username,
      "msg"	=>$this->message,
      "time"	=>$this->time
    );
    if($isAdmin)
    {
      $ret["ip"]=$this->ip;
    }
    return $ret;
  }
}

$posts = [
  new uPost ("Kehvarl", "Hello World"),
  new uPost ("Kehvarl", "Another World", "GM"),
  new uPost ("Kehvarl", "This is a sample post", "ADMIN"),
  new uPost ("Kehvarl", "And another"),
  new uPost ("Kehvarl", "Even more!", "GM"),
  new uPost ("SYSTEM", "System alert", "SYSTEM")
];

echo json_encode(array("room"=>"Main", "posts"=>$posts));
 ?>
