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
  new uPost ("Test", "Hello World"),
  new uPost ("Test", "Another World", "ADMIN")
];

echo json_encode(array("room"=>"Main", "posts"=>$posts));
 ?>
