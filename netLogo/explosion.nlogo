breed [humans human]

humans-own [has-bomb?]

globals[
  x-coords
  y-coords
  blast-center
]

to generate-random-coords
  set x-coords floor (random-xcor)
  set y-coords floor (random-ycor)
end

to setup
  clear-all

  setup-patches
  setup-humans
  set-bomb

  reset-ticks
end

to setup-patches
  ask patches [set pcolor 4]
end

to setup-humans
  set-default-shape humans "person"
  create-humans num-of-humans[
    generate-random-coords
    setxy x-coords y-coords
    set color black
    set has-bomb? false
    separate-humans
  ]
end

to separate-humans
  if any? other turtles-here with [breed = humans][
    generate-random-coords
    setxy x-coords y-coords
    separate-humans
  ]
end

to set-bomb
  let victim one-of humans
  ask victim [set color red set has-bomb? true]
end

to go
  display-labels
  move-humans
  pass-bomb
  explode

  if ticks >= bomb-timer [stop]
  tick
end

to display-labels
  ask turtles with [breed = humans] [
    set label ""
    if show-id? [
      set label who
      set label-color white
    ]
  ]
end

to move-humans
  ask humans[
    rt random 50 - 25
    fd 1
  ]
end

to pass-bomb
  ask humans with [has-bomb?] [
    let next-victim one-of other turtles-here with [breed = humans]
    if next-victim != nobody and random-float 100 < chance-of-pass [
      ask next-victim [
        set has-bomb? true
        set color red
      ]
      set has-bomb? false
      set color black
    ]
  ]
end

to explode
  if ticks = bomb-timer [
    create-blast
    kill-people
  ]
end

to find-blast-center
  let bomber one-of turtles with [has-bomb?]
  ask bomber[
    set blast-center patch-here
  ]
end

to create-blast
  find-blast-center

  let left-bound ([pxcor] of blast-center) - blast-radius
  let right-bound ([pxcor] of blast-center) + blast-radius
  let bottom-bound ([pycor] of blast-center) - blast-radius
  let top-bound ([pycor] of blast-center) + blast-radius

  ask patches with [
    pxcor >= left-bound and pxcor <= right-bound and
    pycor >= bottom-bound and pycor <= top-bound
  ] [
    set pcolor black
  ]
end

to kill-people
  ask humans [if pcolor = black [die]]
end