import json
from typing import List, Tuple, Callable, Optional

def _bits(x: int, n: int) -> List[int]:
    return [(x >> i) & 1 for i in range(n)]

def _nullspace_gf2(R: List[List[int]]) -> List[List[int]]:
    """
    Compute a basis of the right null space (右零空间基) of R (column vectors v such that R v = 0) over GF(2).
    Each basis vector is a list of length n with bits 0/1, representing an XOR selection mask.

    Args:
        R (List[List[int]]): Difference Matrix, where each row represents the xor value of two collided address

    Returns:
        list[list[int]]: Hash function, where each row represents one output bit and its related input bits
    """
    if not R:
        return []   # No constraints: null space is the full space, handled by the caller
    A = [row[:] for row in R]
    r, n = len(A), len(A[0])
    pivots = []
    row = 0
    for col in range(n):
        # Find pivot (主元列) where the bit 1 appears for the first time in current row.
        sel = None
        for i in range(row, r):
            if A[i][col] == 1:
                sel = i
                break
        if sel is None:
            continue
        # Swap pivot into the current row
        A[row], A[sel] = A[sel], A[row]
        # Column elimination (both up and down to get RREF, 行最简阶梯形)
        for i in range(r):
            if i != row and A[i][col] == 1:
                for j in range(col, n):
                    A[i][j] ^= A[row][j]
        pivots.append(col)
        row += 1
        if row == r:
            break

    free_cols = [c for c in range(n) if c not in pivots]
    if not free_cols:
        return []  # Null space dimension is 0

    # In RREF: each pivot row satisfies x_p ⊕ (⊕_{j>p} A[row][j] x_j) = 0
    # For each free column f, construct a basis vector: x_f=1, other free cols=0
    # pivot vars determined by row coefficients
    basis = []
    for f in free_cols:
        v = [0]*n
        v[f] = 1
        # For each pivot row, the value of the pivot column p = coefficient in this row at col f
        for r_idx, p in enumerate(pivots):  # r_idx = row index of the pivot, p = col index of the pivot
            if A[r_idx][f] == 1:
                v[p] ^= 1
        basis.append(v)
    return basis

def _add_to_basis(v: int, basis: List[int]) -> bool:
    x = v
    # 1. For vectors exist in basis, they form an upper triangular matrix (上三角矩阵)
    #    Use these vectors to perform Gaussian elimination (高斯消元, 即初等行变换) on x
    for b in basis:
        hb = b.bit_length() - 1         # find the most significant bit 1 in b
        if hb >= 0 and ((x >> hb) & 1): # If x[hb] = 1, then x ^= b
            x ^= b
            if x == 0:                  # If x is eleminated, we cannot add x to basis
                return False            # because it is linear dependent on existing basis
    # 2. If x add the rank of basis, insert it to the basis.
    #    To maintain the upper triangular matrix, we need to insert x to a proper row.
    hb_x = x.bit_length() - 1
    i = 0
    while i < len(basis) and (basis[i].bit_length() - 1) > hb_x:
        i += 1
    basis.insert(i, x)
    # Update other vectors to make sure that in column hb_x, only x[hb_x] = 1, other v[hb_x] = 0
    # So that the upper triangular feature is maintained. 
    for j, bj in enumerate(basis):
        if j == i: 
            continue
        if ((bj >> hb_x) & 1):
            basis[j] ^= x
    return True

def _min_weight_basis(basis_init: List[List[int]]):
    r = len(basis_init)
    ncols = len(basis_init[0]) 
    if r == 0:
        return [], 0
    B = [int("".join(map(str, v)), 2) for v in basis_init]

    # 1. Extract 1-hot vectors from input ---
    onehots = [v for v in B if v.bit_count() == 1]
    rest    = [v for v in B if v.bit_count() != 1]

    chosen, chk_basis = [], []

    # add onehots to final basis
    for v in onehots:
        chosen.append(v)
        if len(chosen) == r:
            return basis_init # edge case: all vectors in basis_int are 1-hot

    # edge case: all vectors in basis_int are 1-hot
    if not rest:
        return basis_init

    # 2. For rest vectors, enumerate all linear combinations 
    r2 = len(rest)
    # Use bucket sort to resort the weight of all generated vectors
    buckets = [[] for _ in range(ncols + 1)]

    prev_mask, v = 0, 0
     # Use gray code to generate combination
    for k in range(1, 1 << r2):        # The rest list has 2^(len(rest)) subsets 
        mask = k ^ (k >> 1)            # Each mask maps to one subset of rest, e.g. 3 means rest[0] ^ rest[1]
        delta = mask ^ prev_mask       # Generate the next gray code
        i = delta.bit_length() - 1
        v ^= rest[i]                   # We can save some xor operations thanks to the gray code
        w = v.bit_count()
        buckets[w].append(v)           # Add new vector to the bucket
        prev_mask = mask

    # 3. Find len(rest) vectors with the minimal weight
    for w in range(ncols + 1):  # Greedy algorithm: start from vectors with minimal bits 1
        for vec in buckets[w]:
            # If the added vector is linearly independent with others already in the basis
            if _add_to_basis(vec, chk_basis):
                # Choose this vector
                chosen.append(vec)
                if len(chosen) == r:
                    res = []
                    for int_val in chosen:
                        v = [int(i) for i in bin(int_val)[2:]]
                        while(len(v)) < ncols:
                            v.insert(0, 0)
                        res.append(v)
                    return res
    # Other unknown cases
    return []

def infer_linear_xor_hash(xs: List[int], in_bits: Optional[int] = None, auto_calibration: bool = False
                          ) -> Tuple[int, List[List[int]], Callable[[int], int]]:
    """
    xs: A set of mutually colliding inputs (integers)
    in_bits: Input bit-width; if None, inferred from the maximum bit length
    Returns:
      m: Output bit-width (dimension)
      outputs: List of length m; each entry is the list of input bit indices (LSB=0) XORed to form that output bit
      h: Linear hash function (b=0): y_j = XOR_{i in outputs[j]} x_i
    """
    assert(len(xs) >= 2)
    # Find the largest bits of an address
    n = in_bits or max(1, max(x.bit_length() for x in xs))  
    x0 = xs[0]
    # Build Difference Matrix R (R = [[xs[i] ⊕ xs[j] for j in len(xs)] for i in len(xs)])
    diffs = [x ^ x0 for x in xs[1:]]
    R = [_bits(d, n) for d in diffs]
    
    max_bit = max(1, max(x.bit_length() for x in xs), in_bits) 
    max_diff_bit = -1
    for i in range(len(R)):
        for j in range(0, n):
            if R[i][j] == 1 and j > max_diff_bit:
                max_diff_bit = j

    # Special case: if there are no differences (all samples identical),
    # null space is the full space: pick identity projection as linear hash
    if all(d == 0 for d in diffs):
        m = n
        outputs = [[i] for i in range(n)] 
    else:
        # Each basis vector gives an output bit's XOR selection
        basis_init = _nullspace_gf2(R)
        basis = basis_init
        m = len(basis)
        if m == 0:
            # Differences span full space, only constant hash possible 
            # (pure linear gives output dimension 0)
            outputs = []
        else:
            outputs = [[i for i,b in enumerate(v) if b] for v in basis]

    def h(val: int) -> int:
        # Compute integer from outputs specified by XOR combinations
        y = 0
        for j, idxs in enumerate(outputs):
            s = 0
            for i in idxs:
                s ^= (val >> i) & 1
            y |= (s << j)
        return y

    # Verify the correctness of the hash function
    ys = {h(x) for x in xs}
    assert(len(ys) == 1)

    if auto_calibration:
        # Simplify hash function through heuristic pruning
        removed_v = set([i for i in range(max_diff_bit, n)])
        cur_len = len(outputs)
        while(True):
            cur_len = len(outputs)
            for h in outputs:
                if (len(h) == 0):
                    continue
                removed_h = True
                for v in h:
                    if (v not in removed_v):
                        removed_h = False
                    else:
                        for ov in h:
                            removed_v.add(ov)
                if removed_h:
                    outputs.remove(h)
                    break
                
            if (len(outputs) == cur_len):
                break
            else:
                cur_len = len(outputs)
        
        # If a bit appears multiple times, move it to a single bit
        # e.g. [1,2], [1,3], [1,4,5] -> [1], [2], [3], [4,5]
        appeared_v = set()
        repeated_v = set()
        for i in range(len(outputs)):
            for v in outputs[i]:
                if v not in appeared_v:
                    appeared_v.add(v)
                else:
                    repeated_v.add(v)
        for i in range(len(outputs)):
            for v in repeated_v:
                if v in outputs[i]:
                    outputs[i].remove(v)
        for v in repeated_v:
            outputs.append([v])
        # calibration for special stride
        # If each output is contributed at least 2 bits with the same stride, 
        # add more bits larget than max_diff_bit although we do not test them.
        # e.g. [0,30], [1,31], [2,32], [3,33] -> [0,30], [1,31], [2,32], [3,33], [4,34], ...
        same_stride = True
        d = -1
        for h in outputs:
            if (len(h) < 2):
                same_stride = False
                break
            if d == -1:
                d = h[1] - h[0]
            for i in range(1, len(h) - 1):
                if (h[i + 1] - h[i] != d):
                    same_stride = False
        # print(same_stride, max_bit, max_diff_bit)
        if (same_stride):
            for h in outputs:
                for j in range(h[-1] + d, max_bit, d):
                    if(j > max_diff_bit):
                        h.append(j)
        covered_bits = [0 for i in range(max_bit)]
        for h in outputs:
            for v in h:
                covered_bits[v] = 1
        uncovered_bits = []
        for i in range(max_bit):
            if (covered_bits[i] == 0):
                uncovered_bits.append(i)
        while(True):
            if len(uncovered_bits) == 0:
                break
            more_h = set()
            cur_v = uncovered_bits[0]
            for v in range(cur_v, max_bit, d):
                more_h.add(v)
                if v in uncovered_bits:
                    uncovered_bits.remove(v)
            if len(more_h) > 0:
                outputs.append(list(more_h))
            else:
                break
    # print(outputs)
    return outputs

if __name__ == "__main__":
    data = []
    with open("../../data/collide_addr.json", 'r') as f:
        data = json.load(f)
    xs = data[0][0]
    outputs = infer_linear_xor_hash(xs, 48, auto_calibration=True)
    print("outputs = ", outputs)
    
