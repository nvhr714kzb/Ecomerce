<div class="section" id="review-product">
    <div class="section-head">
        <h2>Review this product</h2>
    </div>
    <div class="section-detail">
        <?php
        if (is_login()) {
            if (!is_review($id, $_SESSION['user_id'])) {
        ?>
                <div id="add-review">
                    <p><?php if (isset($message)) echo $message ?></p>
                    <form id="review-form" action="" method="POST">
                        <textarea name="reviewContent" id="review-content" cols="100" rows="6" placeholder=" Enter your review"></textarea><br>
                        <div class="clearfix">
                            <div class="float-left">
                                <label>Your rating: </label>
                                <?php for ($i = 1; $i <= 5; $i++) { ?>
                                    <label class="star" id="star-<?php echo $i ?>" data-index="<?php echo $i ?>">&#9733<input type="radio" name="star" value="<?php echo $i ?>"></label>
                                <?php } ?>
                            </div>
                            <input type="submit" name="submitAddReview" class="float-right" value="Add a review">
                        </div>
                    </form>
                </div>
            <?php
            } else {
                echo "<p>You already have reviewed this product</p>";
            }
            ?>

        <?php } else {
            echo "<p>You must log in to add a review</p>";
        } ?>

        <div class="section" id="list-review">
            <div class="section-head">
                <h2>List reviews</h2>
            </div>
            <div class="section-detail">
                <?php
                if (!empty($list_reviews)) {
                    foreach ($list_reviews as $item) {
                ?>
                        <div class="user-info">
                            <img class="avatar" src="public/images/avatar/<?php echo $item['avatar'] ?>" alt="" width="30px">
                            <strong class="name"><?php echo htmlspecialchars($item['name']) ?></strong>
                        </div>
                        <div class="rating">
                            <ul class="list-star">
                                <?php
                                for ($i = 1; $i <= 5; $i++) {
                                    if ($i <= $item['rating']) {
                                        $color = 'color:#ffcc00;';
                                    } else {
                                        $color = 'color:#ccc;';
                                    }
                                ?>
                                    <li id="<?php echo $i ?>" data-index="<?php echo $i ?>" style="<?php echo $color ?>">&#9733</li>
                                <?php
                                } ?>
                            </ul>
                        </div>
                        <p class="review-date"><?php echo time_ago($item['date_created']) ?></p>
                        <p class="review-content"><?php echo htmlspecialchars($item['review']) ?></p>
                <?php
                    }
                } else {
                    echo "<p>Be the first person to voice your opinions!</p>";
                }
                ?>
            </div>
        </div>
    </div>

</div>