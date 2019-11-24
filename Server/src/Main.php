<?php
class uPost
{
  public $tag;
  public $color;
  public $username;
  public $message;
  public $time;
  public $ip;

  public function __construct($color, $username, $message, $tag="")
  {
    $this->tag = $tag;
    $this->color = $color;
    $this->username = $username;
    $this->message = $message;
    $this->time = date(DATE_W3C, time());
    $this->ip = $_SERVER['REMOTE_ADDR'];
  }

  public function toArray($isAdmin = false)
  {
    $ret = array(
      "tag"	=>$this->tag,
      "color"	=>$this->color,
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
  new uPost ("#000080", "Kehvarl", "Hello World"),
  new uPost ("#000080", "Kehvarl", "Another World", "GM"),
  new uPost ("#000080", "Kehvarl", "This is a sample post", "ADMIN"),
  new uPost ("#000080", "Kehvarl", "And another"),
  new uPost ("#000080", "Kehvarl", "Even more!", "GM"),
  new uPost ("#000080", "SYSTEM", "System alert", "SYSTEM")
];

if(isset($_REQUEST['room']))
  $room = $_REQUEST['room'];
else
  $room = "NONE";

echo json_encode(array("room"=>$room, "posts"=>$posts));
 ?>
