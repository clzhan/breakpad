
export PATH=$(pwd):${PATH}

declare -a lib_arr=(libmediacore.so  libSRRtcEngine.so libcallserver.so)
#declare -a lib_arr=(libmediacore.so libSRRtcEngine.so)
#declare -a lib_arr=(libhello-jni.so )
#declare -a lib_arr=(libsrengine_api.so)

#clean 
rm *.sym *.txt symbols -rf 

# create symbol files
for so in ${lib_arr[@]}
do 
    syms_name=${so}.sym
    echo dump symbol: $syms_name 
    dump_syms ${so} > ${syms_name}
    syms_subdir=`awk 'NR==1' ${syms_name} | awk '{print $4}'`
    
    syms_dir=./symbols/${so}/${syms_subdir} 
    echo mdkir: ${syms_dir}
    mkdir -p ${syms_dir}
    cp ${syms_name} ${syms_dir}/    
    rm ${syms_name}
done

# dump crash stack
cur_dir=$(pwd)
for file in ${cur_dir}/*
do 
    dump_file=`basename $file`
    echo "$dump_file" | grep -q ".dmp"
    if [ $? -eq 0 ] 
    then
        echo dump stack:$file1  
        minidump_stackwalk $dump_file symbols/  > ${dump_file}.txt
    fi  
done
