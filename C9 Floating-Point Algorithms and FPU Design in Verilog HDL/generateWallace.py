from collections import deque
def printWallace(a_length,b_length):
    print("""
    module wallace{}x{}(
        input [{}:0]a,
        input [{}:0]b,
        output [{}:0]sum,c
    );
    """.format(a_length,b_length,a_length-1,b_length-1,a_length+b_length-1));
    print("""
        reg[{}:0]ab[{}:0];
        integer i,j;
        always @(*) begin
            for ( i= 0; i<{};i=i+1) begin
                for (j = 0; j<{}; j=j+1) begin
                    ab[i][j]=b[i]*a[j];
                end
                ab[i][{}:{}]={}'b0;
            end
        end
    """.format(a_length+b_length-1,b_length-1,b_length,a_length,a_length+b_length-1,a_length,b_length))
    A=deque()
    if(b_length%3==2):
        A.append([b_length-2,0])
        A.append([b_length-1,0])
    if(b_length%3==1):
        A.append([b_length-1,0])
    i=0
    while (i<b_length/3):
        print("""       wire [{}:0]sum{},c{};""".format(a_length+b_length-1,i,i))
        print("""       csa #(.WIDTH({}))csa_{}(ab[{}]<<{},ab[{}]<<{},ab[{}]<<{},sum{},c{});"""
            .format(a_length+b_length,i,i*3,i*3,i*3+1,i*3+1,i*3+2,i*3+2,i,i))
        A.append([i,1])#1不移位
        A.append([i,2])#2移一位
        i=i+1
    while(len(A)!=2):
        print("""       wire [{}:0]sum{},c{};""".format(a_length+b_length-1,i,i))
        a1=A.popleft()
        a2=A.popleft()
        a3=A.popleft()
        str1=""
        str2=""
        str3=""
        if(a1[1]==0):
            str1="ab[{}]<<{}".format(a1[0],a1[0])
        elif (a1[1]==1):
            str1="sum{}".format(a1[0])
        else:
            str1="c{}<<1".format(a1[0])
        if(a2[1]==0):
            str2="ab[{}]<<{}".format(a2[0],a2[0])
        elif (a2[1]==1):
            str2="sum{}".format(a2[0])
        else:
            str2="c{}<<1".format(a2[0])
        if (a3[1]==1):
            str3="sum{}".format(a3[0])
        else:
            str3="c{}<<1".format(a3[0])
        print("""       csa #(.WIDTH({}))csa_{}({},{},{},sum{},c{});"""
            .format(a_length+b_length,i,str1,str2,str3,i,i))
        A.append([i,1])#1不移位
        A.append([i,2])#2移一位
        i=i+1

    print("""       assign sum=sum{};""".format(i-1))
    print("""       assign c=c{};""".format(i-1))
    print("""   endmodule""")
printWallace(28,24)