###get cp consensus
sh test.sh order_113ind.depth 1>10fold.depth 
sh motify_run.sh 10fold.depth
##get one IRA region seq
perl get_one_IR.pl final_consensus/ 134504 IRA_seq/
 perl check_missing_rate.pl IRA_seq/ 1>missing_infor.log
sed -n '7,113p' missing_infor.log  | cut -f 1 1>good.ind
sh cat_ind_seq.sh good.ind ./IRA_seq/
