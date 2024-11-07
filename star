<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>星空背景</title>
    <style type="text/css">
        canvas {
            position: fixed;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
        
        /* 新增样式 */
        .centered-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white; /* 文字颜色 */
            font-size: 40px; /* 字体大小 */
            text-align: center; /* 文本居中 */
            z-index: 9999; /* 确保在canvas之上 */
        }

        /* 音乐播放器样式 */
        .music-player {
            position: absolute;
            bottom: 20px; /* 调整位置 */
            left: 50%;
            transform: translateX(-50%);
            z-index: 9999;
        }
    </style>
</head>

<body>

    <div>
        <canvas id="canvas"></canvas>
        <canvas id="snow"></canvas>

        <div class="am-g" style="position: fixed; bottom: 0px;">
            <div class="am-u-sm-12">
                <div style="z-index: 9999" id="player" class="aplayer"></div>
            </div>
        </div>
    </div>

    <!-- 添加居中的三行文字 -->
    <div class="centered-text">
        <div>立冬快乐</div>
        <div>宇宙浩瀚</div>
        <div>尽情探索</div>
    </div>

    <!-- 添加音频播放器 -->
    <div class="music-player">
        <audio controls autoplay loop>
            <source src="https://music.163.com/#/mv?id=14677195" type="audio/mpeg">
            您的浏览器不支持音频元素。
        </audio>
    </div>

    <script type="text/javascript">
        var canvas = document.getElementById('canvas'),
            ctx = canvas.getContext('2d'),
            w = canvas.width = window.innerWidth,
            h = canvas.height = window.innerHeight,

            hue = 217,
            stars = [],
            count = 0,
            maxStars = 1300; //星星数量

        var canvas2 = document.createElement('canvas'),
            ctx2 = canvas2.getContext('2d');
        canvas2.width = 100;
        canvas2.height = 100;

        var half = canvas2.width / 2,
            gradient2 = ctx2.createRadialGradient(half, half, 0, half, half, half);
        gradient2.addColorStop(0.025, '#CCC');
        gradient2.addColorStop(0.1, 'hsl(' + hue + ', 61%, 33%)');
        gradient2.addColorStop(0.25, 'hsl(' + hue + ', 64%, 6%)');
        gradient2.addColorStop(1, 'transparent');

        ctx2.fillStyle = gradient2;
        ctx2.beginPath();
        ctx2.arc(half, half, half, 0, Math.PI * 2);
        ctx2.fill();

        //End cache

        function random(min, max) {
            if (arguments.length < 2) {
                max = min;
                min = 0;
            }

            if (min > max) {
                var hold = max;
                max = min;
                min = hold;
            }

            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        function maxOrbit(x, y) {
            var max = Math.max(x, y),
                diameter = Math.round(Math.sqrt(max * max + max * max));
            return diameter / 2;
            //星星移动范围，值越大范围越小，
        }

        var Star = function () {
            this.orbitRadius = random(maxOrbit(w, h));
            this.radius = random(60, this.orbitRadius) / 8; //星星大小
            this.orbitX = w / 2;
            this.orbitY = h / 2;
            this.timePassed = random(0, maxStars);
            this.speed = random(this.orbitRadius) / 50000; //星星移动速度
            this.alpha = random(2, 10) / 10;

            count++;
            stars[count] = this;
        }

        Star.prototype.draw = function () {
            var x = Math.sin(this.timePassed) * this.orbitRadius + this.orbitX,
                y = Math.cos(this.timePassed) * this.orbitRadius + this.orbitY,
                twinkle = random(10);

            if (twinkle === 1 && this.alpha > 0) {
                this.alpha -= 0.05;
            } else if (twinkle === 2 && this.alpha < 1) {
                this.alpha += 0.05;
            }

            ctx.globalAlpha = this.alpha;
            ctx.drawImage(canvas2, x - this.radius / 2, y - this.radius / 2, this.radius, this.radius);
            this.timePassed += this.speed;
        }

        for (var i = 0; i < maxStars; i++) {
            new Star();
        }

        function animation() {
            ctx.globalCompositeOperation = 'source-over';
            ctx.globalAlpha = 0.5; //尾巴
            ctx.fillStyle = 'hsla(' + hue + ', 64%, 6%, 2)';
            ctx.fillRect(0, 0, w, h)

            ctx.globalCompositeOperation = 'lighter';
            for (var i = 1, l = stars.length; i < l; i++) {
                stars[i].draw();
                canvas2.style.cssText = "display:none";
            };

            window.requestAnimationFrame(animation);
        }
        
        animation();
    </script>

</body>
</html>
