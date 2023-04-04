<div id="content">
    <div class="box">
        <div class="box-head">
            <h3>List posts for new products</h3>
        </div>
        <div class="box-body">
            <ul id="list-post-new-product">
                <?php foreach ($list_post_by_new_product as $item) { ?>
                    <li>
                        <a href="?mod=post&act=list_post_by_product&pId=<?php echo $item['product_id'] ?>" class="post-thumb">
                            <img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="">
                            <h3><?php echo $item['name'] ?></h3>
                            <label for=""><?php echo $item['num_post'] ?> posts</label>
                        </a>
                    </li>
                <?php } ?>
            </ul>
        </div>
    </div>
</div>