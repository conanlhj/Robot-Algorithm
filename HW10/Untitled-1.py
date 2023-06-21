def main():
    env = GridWorld()
    agent = AgentSARSA()
    plt.rc("font", size=5)
    for n_epi in range(1000):
        done = False

    s = env.reset()
    while not done:
        a = agent.select_action(s)
        s_next, r, done = env.step(a)
        agent.update_table((s, a, r, s_next))
        s = s_next
    agent.anneal_eps()

    # Show me the result when it has done!
    opt_q, opt_policy = agent.show_table()

    # Display the opt_q
    fig, ax = plt.subplots()
    plt.imshow(opt_policy, cmap="cool", interpolation="nearest")
    for i in range(MAX_ROW + 1):
        for j in range(MAX_COL + 1):
            tempstr = "{:.4f}".format(opt_q[i][j])
            text = ax.text(j, i, tempstr, ha="center", va="center", color="k")
    plt.show()

    # Display the opt_policy
    # 0:R, 1:L, 2:U, 3:D
    # 0:→, 1:←, 2:↑, 3:↓
    fig, ax = plt.subplots()
    plt.imshow(opt_policy, cmap="cool", interpolation="nearest")
    for i in range(MAX_ROW + 1):
        for j in range(MAX_COL + 1):
            if opt_policy[i][j] == 0:
                tempstr = "→"
            elif opt_policy[i][j] == 1:
                tempstr = "←"
            elif opt_policy[i][j] == 2:
                tempstr = "↑"
            elif opt_policy[i][j] == 3:
                tempstr = "↓"
            elif opt_policy[i][j] == 4:
                tempstr = "↗"
            elif opt_policy[i][j] == 5:
                tempstr = "↙"
            elif opt_policy[i][j] == 6:
                tempstr = "↖"
            else:
                tempstr = "↘"
        text = ax.text(j, i, tempstr, ha="center", va="center", color="k")
    plt.show()
