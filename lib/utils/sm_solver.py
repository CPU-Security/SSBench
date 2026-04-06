import pulp


def integer_solve(x1, x2, x3, x4, x4_, x4__, x5, x6):
    """
    Solve for a feasible integer solution of the variables k1, k2, k3, k4, k5,
    k6, k7, and kp under a set of linear constraints.

    The function builds an integer linear programming model using PuLP and
    returns one feasible solution if it exists.

    Args:
        x1 (int): Input parameter used in constraints involving k3 and kp.
        x2 (int): Input parameter used to define kp = x1 * k3 - x2.
        x3 (int): Control parameter that determines which constraint branch is used.
        x4 (int): Input parameter used in the branch selection for k4/k5 constraints.
        x4_ (int): Input parameter used in k4/k5 constraint construction.
        x4__ (int): Input parameter used in k4/k5 constraint construction.
        x5 (int): Input parameter reserved for constraint logic.
        x6 (int): Input parameter used in the constraint involving k1, k3, and kp.

    Returns:
        list[int]: A feasible integer solution in the form
        [k1, k2, k3, k4, k5, k6, k7, kp].
        Returns an empty list if no feasible solution is found.
    """
    print("Solving parameters, input =", [x1, x2, x3, x4, x4_, x4__, x5, x6])

    # Solve k1~k6 and kp
    # Step 1: Solve k2 and k7
    k2 = -1
    k7 = 0

    # Step 2: Add constraints for k4, k5, and k6
    k6 = -1
    if x3 == -1:
        k4_cons = lambda k3, k4, k5, x4_, x4__: k4 == x4_ - 1
        # If k4 == 0, then k5 = x1 * k3; otherwise, k5 = x4 + kp
        k5_cons = lambda k3, k5, x1, x4_, x4__: k5 == ((x4 + kp) if (x4_ - 1 != 0) else (x1 * k3))
        k6 = 1
    else:
        if x4 <= x2:  # k4 < 0
            k4_cons = lambda k3, k4, k5, x4_, x4__: k4 == x4__ - 1 - x4_ * k3
            k5_cons = lambda k3, k5, x1, x4_, x4__: k5 == x1 * k3
            k6 = -1
        else:  # k4 > 0, k6 = 0
            k4_cons = lambda k3, k4, k5, x4_, x4__: k4 == k4
            k5_cons = lambda k3, k5, x4_, x4__: k5 - kp == x4_ * k4 - x4__
            k6 = 0

    # Step 3: Define the remaining constraints
    cons_1 = lambda kp, k3, x1: kp >= (x1 - 1) * k3
    cons_2 = lambda kp, k3, x1: kp <= x1 * k3 - 1
    cons_3 = lambda kp, k3, x1, x2: kp == x1 * k3 - x2
    cons_4 = k4_cons
    cons_5 = k5_cons
    cons_6 = lambda k1, k3, x5, x6: x1 * k3 + k1 == x6 + kp
    cons_7 = lambda kp: kp >= 0

    # Define integer variables
    # The default lower bound is None unless otherwise specified
    kp = pulp.LpVariable("kp", cat="Integer")
    k1 = pulp.LpVariable("k1", cat="Integer")
    k3 = pulp.LpVariable("k3", cat="Integer")
    k4 = pulp.LpVariable("k4", cat="Integer")
    k5 = pulp.LpVariable("k5", cat="Integer")

    # Objective function:
    # We only need a feasible solution, so use a dummy objective
    model = pulp.LpProblem("Feasible_Integer_Solution", pulp.LpMinimize)
    model += 0

    # Add constraints
    model += cons_1(kp, k3, x1=x1)                     # kp >= (x1 - 1) * k3
    model += cons_2(kp, k3, x1=x1)                     # kp <= x1 * k3 - 1
    model += cons_3(kp, k3, x1=x1, x2=x2)              # kp == x1 * k3 - x2
    model += k4_cons(k3, k4, k5, x4_=x4_, x4__=x4__)
    model += k5_cons(k3, k5, x1=x1, x4_=x4_, x4__=x4__)
    model += cons_6(k1, k3, x5=x5, x6=x6)              # x1 * k3 + k1 == x6 + kp
    model += cons_7(kp)                                # kp >= 0

    # Solve the model
    model.solve(pulp.GLPK_CMD(msg=False))

    # Adjust k1
    if int(k1.varValue) >= int(kp.varValue):
        k1 = 0
    else:
        k1 = int(k1.varValue)

    # Return the result
    if model.status == pulp.LpStatusOptimal:
        answer = [
            int(i) for i in [
                k1, k2, k3.varValue, k4.varValue, k5.varValue,
                k6, k7, kp.varValue
            ]
        ]
        return answer
    else:
        return []


if __name__ == "__main__":
    ans = integer_solve(1, 15, -1, 15, 15, 0, 1, 0)  # i7-9700
    print(ans)