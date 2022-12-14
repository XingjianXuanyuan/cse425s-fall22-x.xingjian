structure SumDistancesToOriginFun = struct
	(* Xingjian Xuanyuan *)
	(* 
	 * note: use of #1 and #2 to access the items of the tuple
	 * leaves some ambiguity of exactly how big the tuple actually is.
	 * this can result in an unresolved flex record error.
	 * therefore, we must explicitly specify the type of xys to be 
	 * (real * real) list.
	 *)
	fun sum_distances_to_origin(xys : (real * real) list) : real =
		case xys of [] => 0.0 | (headx, heady)::tail =>
			sum_distances_to_origin(tail) + 
			Math.sqrt(headx * headx + heady * heady)
end