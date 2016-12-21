function f_err = task31_MSEN (F_gt,F_est)
    [E,F_gt_val] = flow_error_map (F_gt,F_est);
    f_err = sum(sum(E)) / sum(sum(F_gt_val));
end