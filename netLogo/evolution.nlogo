breed [rabbits rabbit]
breed [wolves wolf]
breed [holes hole]

rabbits-own [initial-energy energy vision-range speed is-hunted]
wolves-own [initial-energy energy vision-range speed target-xcor target-ycor]

globals[
  x-coords
  y-coords
]

to setup
  clear-all
  setup-patches
  setup-rabbits
  setup-wolves
  reset-ticks
end

to generate-random-coords
  set x-coords floor (random-xcor)
  set y-coords floor (random-ycor)
end

to setup-rabbits
  set-default-shape rabbits "rabbit"
  create-rabbits number-of-rabbits [
    generate-random-coords
    setxy x-coords y-coords
    set color white
    set initial-energy (random 21) + 10
    set energy initial-energy
    set speed 2
    set vision-range 4
    set is-hunted false
    separate-rabbits
  ]
end

to separate-rabbits
  if any? other turtles-here with [breed = rabbits] [
    generate-random-coords
    setxy x-coords y-coords
    separate-rabbits
  ]
end

to setup-wolves
  set-default-shape wolves "wolf"
  create-wolves number-of-wolves[
    setxy random-pxcor random-pycor
    set color black
    set initial-energy (random 51) + 50
    set energy initial-energy
    set speed 3
    set vision-range 10
    separate-wolves
  ]
end

to separate-wolves
  if any? other wolves-here [
    fd 1
    separate-wolves
  ]
end

to setup-patches
  ask patches [
    set pcolor 57
    if random 100 < 2 [set pcolor 138]
  ]
end

;; <-- ending setup procedures -->

to go
  display-labels
  regrow-grass
  eat-weeds
  make-new-rabbits
  make-new-wolves
  move-rabbits
  move-wolves

  if ticks >= 100 [stop]
  tick
end

to display-labels
  ask turtles with [breed = wolves or breed = rabbits] [
    set label ""
    if show-energy? [
      set label energy
    ]
  ]
end

to eat-weeds
  ask rabbits [
    if not is-hunted[
      if pcolor = 57 [
        set pcolor 59
        set energy energy + 5
      ]
      if pcolor = 138 [
        set pcolor 57
        set energy energy + 10
      ]
    ]
  ]
end

to regrow-grass
  ask patches [
    if pcolor = 59 [
      if random 100 < 2 [set pcolor 57]
      if random 1000 < 5 [set pcolor 138]
    ]
  ]
end

;; <-- hatching evolved turtles (both rabbits and wolves) -->

to make-new-rabbits
  ask rabbits with [energy > 75] [
  ;; while using 'ask', all the offsprings inherit the parent's properties
    set energy energy - 50
    let new-rabbits random 4 + 1;
    repeat new-rabbits[
      hatch 1[
        ;; each offspring receives random better properties (worst case, they are the same as the parent's)
        set energy (initial-energy + random 5 + 1)
        set vision-range (vision-range + random 2)
        set speed (speed + random 2)
      ]
    ]
  ]
end

to make-new-wolves
  ask wolves with [energy > 250][
    set energy energy - 150
    hatch 1[
      set energy (initial-energy + random 10 + 1)
      set vision-range (vision-range + random 2)
      set speed (speed + random 2)
    ]
  ]
end

to move-wolves
  ask wolves[
    set energy energy - 2
    let target-id is-target-detected
    ifelse target-id != nobody [
      hunt-target target-id
    ][
      move-randomly
    ]
  ]
  ask wolves with [energy < 1] [die]
end

to move-randomly
  rt random 50 - 25
  fd 1
end

to-report is-target-detected
  let potential-targets turtles in-radius vision-range with [breed = rabbits]

  ifelse any? potential-targets [
    let closest-target min-one-of potential-targets [distance myself]
    set target-xcor [xcor] of closest-target
    set target-ycor [ycor] of closest-target
    let target-id [who] of closest-target

    report target-id
  ] [
    report nobody
  ]
end

to hunt-target [target-id]
  face patch target-xcor target-ycor
  let distance-to-target distance patch target-xcor target-ycor

  ifelse distance-to-target >= speed [
    fd speed
    set energy energy - 3
  ][
    fd distance-to-target
  ]

  kill-rabbit target-id
end

to kill-rabbit [target-id]
  let target one-of rabbits with [who = target-id]
  let wolf-on-patch false
  let target-x round [xcor] of target
  let target-y round [ycor] of target
  ask wolves [
    if xcor = target-x and ycor = target-y [
      set wolf-on-patch true
    ]
  ]
  if wolf-on-patch [
    ask target [die]
    ask wolves-here [
      set energy energy + 100
    ]
  ]
end


to move-rabbits
  detect-predators
  ask rabbits [
    ifelse is-hunted [
      escape
    ][
      move-randomly
    ]
  ]
  ask rabbits with [energy < 1] [die]
end

to detect-predators
  ask rabbits [
    ifelse any? wolves in-radius vision-range [
      set is-hunted true
    ] [
      set is-hunted false
    ]
  ]
end

to escape
  if is-hunted [
    let closest-wolf min-one-of wolves in-radius vision-range [distance myself]
    if closest-wolf != nobody [
      if [xcor] of closest-wolf != xcor or [ycor] of closest-wolf != ycor [
        let opposite-heading towards closest-wolf - 180
        ifelse opposite-heading < -180 [
          set opposite-heading opposite-heading + 360
        ][
          set heading opposite-heading
          fd speed
        ]
      ]
    ]
  ]
end