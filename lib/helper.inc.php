<?php
function build($link)
{
       $base = 'http://' . getenv('SERVER_NAME') . '';
       if (defined('HTTP_SERVER_PORT') && HTTP_SERVER_PORT != '80') {
              $base .= ':' . HTTP_SERVER_PORT;
       }
       $link = $base . VIRTUAL_LOCATION . $link;
       return htmlspecialchars($link, ENT_QUOTES);
}
function check_request()
{
       if (isset($_GET['mod'], $_GET['act'], $_GET['id']) && $_GET['mod'] === 'product' && $_GET['act'] === 'detail_product') {
              $proper_url = build('phone/detail/' . create_slug(get_detail_phone((int)$_GET['id'])['name']) . '/' . (int)$_GET['id']);
       } elseif (isset($_GET['mod'], $_GET['act'], $_GET['catId']) && $_GET['mod'] === 'product' && $_GET['act'] === 'browse') {
              $proper_url = build('phone/' . create_slug(get_detail_category((int)$_GET['catId'])['category']) . '/' . (int)$_GET['catId']);
              if(isset($_GET['page'])){
                     $proper_url = build('phone/' . create_slug(get_detail_category((int)$_GET['catId'])['category']) . '/' . (int)$_GET['catId']) . '/' .(int)$_GET['page'];
              }
       } elseif (isset($_GET['mod'], $_GET['act'], $_GET['postId']) && $_GET['mod'] === 'post' && $_GET['act'] === 'detail_post') {
              $proper_url = build('post/' . create_slug(get_detail_post((int)$_GET['postId'])['title']) . '/' . (int)$_GET['postId']);
       } elseif (isset($_GET['mod'], $_GET['act'], $_GET['pId']) && $_GET['mod'] === 'post' && $_GET['act'] === 'list_post_by_product') {
              $proper_url = build('post/product/' . create_slug(get_detail_phone((int)$_GET['pId'])['name']) . '/' . (int)$_GET['pId']);
       }
       if (isset($proper_url)) {
              $requested_url = build(str_replace(VIRTUAL_LOCATION, '', $_SERVER['REQUEST_URI']));
              if ($proper_url != $requested_url) {
                     ob_clean();
                     header('HTTP/1.1 301 Moved Permanently');
                     header('Location: ' . $proper_url);
                     flush();
                     ob_flush();
                     ob_end_clean();
                     exit();
              }
       }
}
function cur_page_url($param = '')
{

       $pageURL = 'http';
       if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') {
              $pageURL .= 's';
       }
       $pageURL .= '://';
       if ($_SERVER['SERVER_PORT'] != '80') {
              $pageURL .= $_SERVER['SERVER_NAME'] . ':' . $_SERVER['SERVER_PORT'] . $_SERVER['REQUEST_URI'];
       } else {
              $pageURL .= $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'];
       }
       $pageURL .= $param;
       return $pageURL;
}
function clean_url_text($str)
{
       // $not_accept = '#[^-a-zA-Z0-9_ ]#';//for english
       $not_accept = '#[^-a-zA-Z0-9_ à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ
       |è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ
       |ì|í|ị|ỉ|ĩ
       |ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ
       |ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ
       |ỳ|ý|ỵ|ỷ|ỹ
       |đ
       |À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ
       |È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ
       |Ì|Í|Ị|Ỉ|Ĩ
       |Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ
       |Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ
       |Ỳ|Ý|Ỵ|Ỷ|Ỹ
       |Đ]#';//for vietnamese
       $str = preg_replace($not_accept, '', $str);
       $str = trim($str);
       $str = preg_replace('#[-_ ]+#', '-', $str);
       // return strtolower($str);
       return $str;
}
function create_slug($string)
{
       $search = array(
              '#(à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ)#',
              '#(è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ)#',
              '#(ì|í|ị|ỉ|ĩ)#',
              '#(ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ)#',
              '#(ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ)#',
              '#(ỳ|ý|ỵ|ỷ|ỹ)#',
              '#(đ)#',
              '#(À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ)#',
              '#(È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ)#',
              '#(Ì|Í|Ị|Ỉ|Ĩ)#',
              '#(Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ)#',
              '#(Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ)#',
              '#(Ỳ|Ý|Ỵ|Ỷ|Ỹ)#',
              '#(Đ)#',
              "/[^a-zA-Z0-9\-\_]/",
       );
       $replace = array(
              'a',
              'e',
              'i',
              'o',
              'u',
              'y',
              'd',
              'A',
              'E',
              'I',
              'O',
              'U',
              'Y',
              'D',
              '-',
       );
       $string = preg_replace($search, $replace, $string);
       $string = trim($string);
       $string = preg_replace('/(-)+/', '-', $string);
       $string = strtolower($string);
       return $string;
}
function time_ago($timestamp)
{
       $time_ago = strtotime($timestamp);
       $current_time = time();
       $time_difference = $current_time - $time_ago;
       $seconds = $time_difference;
       $minutes = round($seconds / 60);           // value 60 is seconds  
       $hours = round($seconds / 3600);           //value 3600 is 60 minutes * 60 sec  
       $days = round($seconds / 86400);          //86400 = 24 * 60 * 60;  
       $weeks = round($seconds / 604800);          // 7*24*60*60;  
       $months = round($seconds / 2629440);     //((365+365+365+365+366)/5/12)*24*60*60  
       $years = round($seconds / 31553280);     //(365+365+365+365+366)/5 * 24 * 60 * 60  
       if ($seconds <= 60) {
              return "Just Now";
       } else if ($minutes <= 60) {
              if ($minutes == 1) {
                     return "one minute ago";
              } else {
                     return "$minutes minutes ago";
              }
       } else if ($hours <= 24) {
              if ($hours == 1) {
                     return "an hour ago";
              } else {
                     return "$hours hours ago";
              }
       } else if ($days <= 7) {
              if ($days == 1) {
                     return "yesterday";
              } else {
                     return "$days days ago";
              }
       } else if ($weeks <= 4.3) //4.3 == 52/12  
       {
              if ($weeks == 1) {
                     return "a week ago";
              } else {
                     return "$weeks weeks ago";
              }
       } else {
              return date('d/m/Y', strtotime($timestamp));
       }
}
function date_formate($timestamp)
{
       return date('d/m/Y', strtotime($timestamp));
}

function category_tree($data, $parent_id = 0, $level = 0)
{
       $result = [];
       foreach ($data as $item) {
              if ($item['parent_cat_id'] == $parent_id) {
                     $item['level'] = $level;
                     $result[] = $item;
                     $child = category_tree($data, $item['id'], $level + 1);
                     $result = array_merge($result, $child);
              }
       }
       return $result;
}
function link_pagination($numPage, $page, $url)//for sale
{
       // array page_array[] is for save link
       if ($numPage > 4) {
              if ($page < 5) { //for example: previous 1 2 3 4 5 ... 70 Next
                     for ($i = 1; $i <= 5; $i++) {
                            $page_array[] = $i;
                     }
                     $page_array[] = '...';
                     $page_array[] = $numPage;
              } else {
                     $end_limit = $numPage - 5;
                     if ($page > $end_limit) { //for example: previous 1 ...65 66 67 68 69 70 Next
                            $page_array[] = 1;
                            $page_array[]  = '...';
                            for ($i = $end_limit; $i <= $numPage; $i++) {
                                   $page_array[] = $i;
                            }
                     } else { //for example: previous 1 ... 4 5 6 ... 70 Next
                            $page_array[] = 1;
                            $page_array[]  = '...';
                            for ($i = $page - 1; $i <= $page + 1; $i++) {
                                   $page_array[] = $i;
                            }
                            $page_array[]  = '...';
                            $page_array[] = $numPage;
                     }
              }
       } else { //previous 1 2 3 4  Next
              for ($i = 1; $i <= $numPage; $i++) {
                     $page_array[] = $i;
              }
       }
       $page_link  = '';
       for ($i = 0; $i < count($page_array); $i++) {
              if ($page == $page_array[$i]) {
                     //previous link
                     $previous_id = $page_array[$i] - 1;
                     if ($previous_id > 0) {
                            // &page=  ------->  /
                            $previous_link  =  "<li id='{$previous_id}' class='page-item'><a class='page-link' href='{$url}/{$previous_id}'>Previous</a></li>";
                     } else {
                            $previous_link  =  "<li class='page-item disabled'><a class='page-link' href='javascript:void(0)'>Previous</a></li>";
                     }
                     //current link
                     $page_link  .=  "<li id='{$page_array[$i]}' class='page-item active'><a class='page-link' href='{$url}/{$page_array[$i]}'>{$page_array[$i]}</a></li>";

                     //next link
                     $next_id = $page_array[$i] + 1;
                     if ($next_id > $numPage) {
                            $next_link  =  "<li class='page-item disabled'><a class='page-link' href='javascript:void(0)'>Next</a></li>";
                     } else {
                            $next_link  =  "<li id='{$next_id}' class='page-item'><a class='page-link' href='{$url}/{$next_id}'>Next</a></li>";
                     }
              } else {
                     if ($page_array[$i] == '...') {
                            //link ...
                            $page_link  .=  "<li class='page-item disabled'><a class='page-link' href='javascript:void(0)'>...</a></li>";
                     } else {
                            //link is not current and ...
                            $page_link  .=  "<li id='{$page_array[$i]}' class='page-item'><a class='page-link' href='{$url}/{$page_array[$i]}'>{$page_array[$i]}</a></li>";
                     }
              }
       }
?>
       <!-- show pagination -->
       <ul class="pagination float-right">
              <?php echo $previous_link . $page_link . $next_link  ?>
       </ul>
<?php
}
function pagination($numPage, $page, $url)//not for sale
{
       // array page_array[] is for save link
       if ($numPage > 4) {
              if ($page < 5) { //for example: previous 1 2 3 4 5 ... 70 Next
                     for ($i = 1; $i <= 5; $i++) {
                            $page_array[] = $i;
                     }
                     $page_array[] = '...';
                     $page_array[] = $numPage;
              } else {
                     $end_limit = $numPage - 5;
                     if ($page > $end_limit) { //for example: previous 1 ...65 66 67 68 69 70 Next
                            $page_array[] = 1;
                            $page_array[]  = '...';
                            for ($i = $end_limit; $i <= $numPage; $i++) {
                                   $page_array[] = $i;
                            }
                     } else { //for example: previous 1 ... 4 5 6 ... 70 Next
                            $page_array[] = 1;
                            $page_array[]  = '...';
                            for ($i = $page - 1; $i <= $page + 1; $i++) {
                                   $page_array[] = $i;
                            }
                            $page_array[]  = '...';
                            $page_array[] = $numPage;
                     }
              }
       } else { //previous 1 2 3 4  Next
              for ($i = 1; $i <= $numPage; $i++) {
                     $page_array[] = $i;
              }
       }
       $page_link  = '';
       for ($i = 0; $i < count($page_array); $i++) {
              if ($page == $page_array[$i]) {
                     //previous link
                     $previous_id = $page_array[$i] - 1;
                     if ($previous_id > 0) {
                            // &page=  ------->  /
                            $previous_link  =  "<li id='{$previous_id}' class='page-item'><a class='page-link' href='{$url}&page={$previous_id}'>Previous</a></li>";
                     } else {
                            $previous_link  =  "<li class='page-item disabled'><a class='page-link' href='javascript:void(0)'>Previous</a></li>";
                     }
                     //current link
                     $page_link  .=  "<li id='{$page_array[$i]} class='page-item active'><a class='page-link' href='{$url}&page={$page_array[$i]}'>{$page_array[$i]}</a></li>";

                     //next link
                     $next_id = $page_array[$i] + 1;
                     if ($next_id > $numPage) {
                            $next_link  =  "<li class='page-item disabled'><a class='page-link' href='javascript:void(0)'>Next</a></li>";
                     } else {
                            $next_link  =  "<li id='{$next_id} class='page-item'><a class='page-link' href='{$url}&page={$next_id}'>Next</a></li>";
                     }
              } else {
                     if ($page_array[$i] == '...') {
                            //link ...
                            $page_link  .=  "<li class='page-item disabled'><a class='page-link' href='javascript:void(0)'>...</a></li>";
                     } else {
                            //link is not current and ...
                            $page_link  .=  "<li id='{$page_array[$i]}' class='page-item'><a class='page-link' href='{$url}&page={$page_array[$i]}'>{$page_array[$i]}</a></li>";
                     }
              }
       }
?>
       <!-- show pagination -->
       <ul class="pagination float-right">
              <?php echo $previous_link . $page_link . $next_link  ?>
       </ul>
<?php
}
function pagination_simple($category, $catId, $page, $number_page)
{
       $str_pagging = '<ul id="pagination">';
       if ($page > 1) {
              $page_prev = $page - 1;
              $str_pagging .= "<li id='$page_prev' class = 'prev pagination_link'><a href = '?mod=product&act=browse&category=$category&catId=$catId&page=$page_prev'><</a></li>";
       }

       for ($i = 1; $i <= $number_page; $i++) {
              $active = '';
              if ($page == $i) {
                     $active = 'active';
              }
              $str_pagging .= "<li id='$i' class = 'page-number $active pagination_link'><a href = '?mod=product&act=browse&category=$category&catId=$catId&page=$i'>$i</a></li>";
       }

       if ($page < $number_page) {
              $page_next = $page + 1;
              $str_pagging .= "<li id='$page_next' class = 'next pagination_link'><a href = '?mod=product&act=browse&category=$category&catId=$catId&page=$page_next'>></a></li>";
       }
       $str_pagging .= '<ul>';
       return $str_pagging;
}
