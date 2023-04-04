<?php
       echo "<ul class = 'list-brand'>";
       while($row = mysqli_fetch_array($r, MYSQLI_ASSOC)){
              echo"
              <li>
                     <h2>".htmlspecialchars($row['category'])."</h2>
                     <img src = 'public/images/badminton/".htmlspecialchars($row['image'])."' alt = '".htmlspecialchars($row['category'])." racket'>
                     <p>".htmlspecialchars($row['description'])."</p>
                     <a href = '?mod=product&act=browse&type=$type&cat=".htmlspecialchars(urldecode($row['category']))."&id={$row['id']}'>View all ".htmlspecialchars($row['category'])." racket</a>
              </li>
              ";
       }
       echo "</ul>";