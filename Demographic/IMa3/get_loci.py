from contextlib import ExitStack
from itertools import zip_longest
import os
def handle(i,num,lines_data,names_list):
    n_l = ['']*len(names_list)
    for v_num in range(len(lines_data[0])):
        num+=1
        if 'N' in set([x[v_num] for x in lines_data]):
            if len(n_l[0]) >=500:
                file_need = open(wk_dir+'loci'+str(i)+'.fasta','w')
                i += 1
                file_need.write(str(len(names_list))+' '+str(len(n_l[0])) +'begin_at:'+str(num) +' '+'\n')
                for index,value in enumerate(names_list):
                    file_need.write(value+n_l[index]+'\n')
                file_need.close()
                break
            else:
                pass
            n_l = ['']*len(names_list)
        elif len(n_l[0])>=1000:
            file_need = open(wk_dir+'loci'+str(i)+'.fasta','w')
            i += 1
            file_need.write(str(len(names_list))+' '+str(len(n_l[0])) +'begin_at:'+str(num) +' '+'\n')
            for index,value in enumerate(names_list):
                file_need.write(value+n_l[index]+'\n')
            file_need.close()
            break
        else:
            for n_v,v_v in enumerate([x[v_num] for x in lines_data]):
                n_l[n_v] = n_l[n_v] + v_v
    return i,num




wk_dir = './'   ##input consensus sequence dir
file_list = os.listdir(wk_dir)
flist = []
for file_name in file_list:
    if file_name.endswith('.fasta'):
        flist.append(file_name)

with ExitStack() as stack:
    files = [stack.enter_context(open(wk_dir+fname)) for fname in flist]
    names_list = ['>'+fname.strip('.fasta')+'\n' for fname in flist]
    i = 0
    for lines in zip_longest(*files):
        if all([x.startswith('>Contig') for x in lines]): #####keep Contig SNPs
            pass
        elif lines[0].startswith('>Qrob_H'): ###ignore the some scaffold SNPs
            break
        else:
            lines = [x.strip('/n') for x in lines]
            num = 19999 ####LD distance - 1
            while True:
                if num <len(lines[0]):
                    i,num = handle(i,num,[x[num:] for x in lines],names_list)
                    num += 20000 #### LD distance
                    print(i,num)
                else:
                    break
