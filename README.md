# R-cade games

## Motivation

I read a great article of Peter Prevos **R-Cade Games: Simulating the Legendary Pong Game in R** (see references). I found it really inspiring and decided to try myself go a step further - use continuous user input in the R language - thanks to Shiny it is possible. Here is the result. 

## Pong

To play `pong` use this commands:

```
library(shiny)
runGitHub(repo = 'r-cade-games', username = 'JacekPardyak', subdir = 'pong')
```

In the app, you should see a bouncing ball resembling this movie:

![[Bouncing ball in #R](https://www.tiktok.com/@pl.in.nl/video/7039045605427105029) by [pl.in.nl](https://www.tiktok.com/@pl.in.nl)](https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/0c6207fa0c9a4387984ce7444744cc91?x-expires=1638925200&x-signature=wM5mxotWUMzY6FBnH9pR5aruQTo%3D)

https://www.tiktok.com/@pl.in.nl/video/7039045605427105029?lang=en&is_copy_url=0&is_from_webapp=v1&sender_device=pc&sender_web_id=6949257532691531270

Here is a notebook to help you make such a animations in R: https://github.com/JacekPardyak/r-cade-games/blob/master/Pong-animation.ipynb

Here is the app script:
https://github.com/JacekPardyak/r-cade-games/blob/master/pong/app.R

# Further work

Developers may decide to include `sound` and `text` in the canvas. For me it was rather out of current scope :).

# References

https://lucidmanager.org/data-science/pong/ 