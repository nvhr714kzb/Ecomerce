window.onload = function() {


        function imagezoom(imgID, resultID) {
            var img, lens, result, cx, cy;
            //get result and image
            img = document.getElementById(imgID);
            result = document.getElementById(resultID);

            //create lens
            lens = document.createElement("DIV");
            lens.setAttribute("class", "img-zoom-lens");
            img.parentElement.insertBefore(lens, img);

            //ti le cua result so voi lens
            cx = result.offsetWidth / lens.offsetWidth; //offset = w + p + b
            cy = result.offsetHeight / lens.offsetHeight;



            lens.addEventListener("mousemove", moveLens);
            img.addEventListener("mousemove", moveLens);

            // lens.addEventListener("touchmove", moveLens);
            // img.addEventListener("touchmove", moveLens);

            function moveLens(e) {
                //add background and size cho result: BAt buoc de o day neu ko se khong cap nhat lien tuc
                result.style.backgroundImage = "url('" + img.src + "')";
                result.style.backgroundSize = (img.width * cx) + "px " + (img.height * cy) + "px"; //width = w
                var pos, x, y;
                // e.preventDefault();
                pos = getCursorPos(e);
                x = pos.x - (lens.offsetWidth / 2);
                y = pos.y - (lens.offsetHeight / 2);

                if (x > img.width - lens.offsetWidth) {
                    x = img.width - lens.offsetWidth;
                }
                if (x < 0) {
                    x = 0;
                }
                if (y > img.height - lens.offsetHeight) {
                    y = img.height - lens.offsetHeight;
                }
                if (y < 0) {
                    y = 0;
                }

                lens.style.left = x + "px";
                lens.style.top = y + "px";

                result.style.backgroundPosition = "-" + (x * cx) + "px -" + (y * cy) + "px";
            }

            function getCursorPos(e) { //get vi tri con tro
                var a, x = 0,
                    y = 0;
                // e = e || window.event;
                a = img.getBoundingClientRect(); // return w , h(+b +p); left-right theo viewport
                x = e.pageX - a.left;
                y = e.pageY - a.top;

                x = x - window.pageXOffset; // so pixel khi cuon ngang pageXOffset = scrollY
                y = y - window.pageYOffset;

                return {
                    x: x,
                    y: y
                };
            }
        }
        imagezoom("my-img", "my-result");
    }
    // =========================LIST THUMB=====================
$(document).ready(function() {
    //Set src cua li dau tien cho show
    var src_img_first = $("#list-thumb li:first-child a img").attr("src");
    $("#thumb #my-img").attr("src", src_img_first);
    //set border cho li dau tien
    $("#list-thumb li:first-child").addClass("active");

    // Su kien khi click
    var src_img_click;
    $("#list-thumb li a").click(function() {
        src_img_click = $(this).children("img").attr("src");
        $("#thumb #my-img").attr("src", src_img_click);
        //Them border cho phan tu duoc click
        $("#list-thumb li").removeClass("active");
        $(this).parent("li").addClass("active");
        return false;
    });
});