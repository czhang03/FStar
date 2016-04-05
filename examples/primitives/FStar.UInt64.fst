module FStar.UInt64

open FStar.Ghost
open IntLib
open Sint

assume val n: x:pos{x = 64}

type uint64 = usint n
type uint128 = usint (2*n)
type limb = uint64
type wide = uint128

let (zero:uint64) = uzero n
let (one:uint64) = uone n
let (ones:uint64) = uones n

let (zero_wide:wide) = uzero (2*n)
let (one_wide:wide) = uone (2*n)
let (ones_wide:wide) = uones (2*n)

let (max_int:erased nat) = eumax_int #n
let (min_int:erased nat) = eumin_int #n

let (bits:pos) = n

(* Standard operators *)
val add: a:uint64 -> b:uint64{v a + v b < reveal max_int} -> Tot uint64
let add a b = uadd #n a b
val add_mod: uint64 -> uint64 -> Tot uint64
let add_mod a b = uadd_mod #n a b
val sub: a:uint64 -> b:uint64{v a - v b >= reveal min_int} -> Tot uint64
let sub a b = usub #n a b
val sub_mod: uint64 -> uint64 -> Tot uint64
let sub_mod a b = usub_mod #n a b
val mul: a:uint64 -> b:uint64{v a * v b < reveal max_int} -> Tot uint64
let mul a b = umul #n a b
val mul_mod: a:uint64 -> b:uint64 -> Tot uint64
let mul_mod a b = umul_mod #n a b
val mul_wide: uint64 -> uint64 -> Tot uint128
let mul_wide a b = umul_large #n a b
val div: uint64 -> b:uint64{v b <> 0} -> Tot uint64
let div a b = udiv #n a b
val rem: uint64 -> b:uint64{v b <> 0} -> Tot uint64
let rem a b = umod #n a b

val logand: uint64 -> uint64 -> Tot uint64
let logand a b = ulogand #n a b
val logxor: uint64 -> uint64 -> Tot uint64
let logxor a b = ulogxor #n a b
val logor: uint64 -> uint64 -> Tot uint64
let logor a b = ulogor #n a b
val lognot: uint64 -> Tot uint64
let lognot a = ulognot #n a

val shift_left: uint64 -> nat -> Tot uint64
let shift_left a s = ushift_left #n a s
val shift_right: uint64 -> nat -> Tot uint64
let shift_right a s = ushift_right #n a s

let rotate_left a s = urotate_left #n a s
let rotate_right a s = urotate_right #n a s

(* Standard operators for wides *)
val add_wide: a:wide -> b:wide{v a + v b < pow2 (2*n)} -> Tot wide
let add_wide a b = uadd #(2*n) a b
val add_mod_wide: wide -> wide -> Tot wide
let add_mod_wide a b = uadd_mod #(2*n) a b
val sub_wide: a:wide -> b:wide{v a - v b >= 0} -> Tot wide
let sub_wide a b = usub #(2*n) a b
val sub_mod_wide: wide -> wide -> Tot wide
let sub_mod_wide a b = usub_mod #(2*n) a b
val mul_wide_wide: a:wide -> b:wide{v a * v b < pow2 (2*n)} -> Tot wide
let mul_wide_wide a b = umul #(2*n) a b
val mul_mod_wide: a:wide -> b:wide -> Tot wide
let mul_mod_wide a b = umul_mod #(2*n) a b
val div_wide: wide -> b:wide{v b <> 0} -> Tot wide
let div_wide a b = udiv #(2*n) a b
val rem_wide: wide -> b:wide{v b <> 0} -> Tot wide
let rem_wide a b = umod #(2*n) a b

val logand_wide: wide -> wide -> Tot wide
let logand_wide a b = ulogand #(2*n) a b
val logxor_wide: wide -> wide -> Tot wide
let logxor_wide a b = ulogxor #(2*n) a b
val logor_wide: wide -> wide -> Tot wide
let logor_wide a b = ulogor #(2*n) a b
val lognot_wide: wide -> Tot wide
let lognot_wide a = ulognot #(2*n) a

val shift_left_wide: wide -> nat -> Tot wide
let shift_left_wide a s = ushift_left #(2*n) a s
val shift_right_wide: wide -> nat -> Tot wide
let shift_right_wide a s = ushift_right #(2*n) a s

let rotate_left_wide a s = urotate_left #(2*n) a s
let rotate_right_wide a s = urotate_right #(2*n) a s

val to_uint64: sint -> Tot uint64
let to_uint64 s = to_usint n s

(* Infix operators *)
let op_Hat_Less_Less = shift_left
let op_Hat_Greater_Greater = shift_right
let op_Hat_Plus = add
let op_Hat_Plus_Percent = add_mod
let op_Hat_Subtraction = sub
let op_Hat_Subtraction_Percent = sub_mod
let op_Hat_Star = mul
let op_Hat_Star_Percent = mul_mod
let op_Hat_Star_Hat = mul_wide
let op_Hat_Hat = logxor  
let op_Hat_Amp = logand
let op_Hat_Bar = logor
let op_Less_Less_Less = rotate_left 
let op_Greater_Greater_Greater = rotate_right

(* Wide infix operators *)
let op_Hat_Hat_Less_Less = shift_left_wide
let op_Hat_Hat_Greater_Greater = shift_right_wide
let op_Hat_Hat_Plus = add_wide
let op_Hat_Hat_Plus_Percent = add_mod_wide
let op_Hat_Hat_Subtraction = sub_wide
let op_Hat_Hat_Subtraction_Percent = sub_mod_wide
let op_Hat_Hat_Star = mul_wide_wide
let op_Hat_Hat_Star_Percent = mul_mod_wide
let op_Hat_Hat_Hat = logxor_wide
let op_Hat_Hat_Amp = logand_wide
let op_Hat_Hat_Bar = logor_wide
let op_Hat_Less_Less_Less = rotate_left_wide
let op_Hat_Greater_Greater_Greater = rotate_right_wide

assume val of_string: string -> Tot uint64
assume val of_int: int -> Tot uint64

// Constant time comparison masking functions
assume val eq: x:limb -> y:limb -> Tot (z:limb{(v x = v y <==> v z = pow2 64 - 1)
								  /\ (v x <> v y <==> v z = 0)})
assume val gte: x:limb -> y:limb -> Tot (z:limb{(v x >= v y <==> v z = pow2 64 - 1)
								  /\ (v x < v y <==> v z = 0)})

assume val wide_to_limb: wide -> Tot limb
assume val limb_to_wide: limb -> Tot wide
