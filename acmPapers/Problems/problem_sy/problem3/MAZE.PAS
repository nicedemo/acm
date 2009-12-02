Program Maze(input,output);	{�����⣺Σ�յ��Թ�}
const   inputfile          =       'maze.in';
        outputfile         =       'maze.out';
        MAXN               =       10;
type    newtype            =       array [0..MAXN*MAXN*2+1] of integer;
var     c,f,g,w            :       array [0..MAXN*MAXN*2+1] of ^ newtype;
        a,b,n,v            :       integer;
procedure initialize;		{�������ݣ�����ͼ}
var  i,j,k,x,y,x0,y0,x1,y1     :    integer;
begin
  assign(input,inputfile);
  reset(input);
  read(a,b);
  v:=a*b*2+1;
  for i:=0 to v do		{�����ڴ棬��������}
    begin
      new(c[i]);new(f[i]);
      new(w[i]);new(g[i]);
      fillchar(c[i]^,sizeof(c[i]^),0);
      fillchar(f[i]^,sizeof(f[i]^),0);
      fillchar(g[i]^,sizeof(g[i]^),0);
      fillchar(w[i]^,sizeof(w[i]^),0);
    end;
  for i:=1 to a do		{��ȡÿ���Σ�ճ̶ȣ�����ÿ����������������}
    for j:=1 to b do
      begin
        read(w[(i-1)*b+j]^[(i-1)*b+j+a*b]);
        c[(i-1)*b+j]^[(i-1)*b+j+a*b]:=1;
      end;
  read(k);
  for i:=1 to k do		{��ȡ������ͨ�ĵ�Ԫ�������ǵ��������������}
    begin
      read(x0,y0,x1,y1);
      c[(x0-1)*b+y0+a*b]^[(x1-1)*b+y1]:=1;
      c[(x1-1)*b+y1+a*b]^[(x0-1)*b+y0]:=1;
    end;
  read(n);
  for i:=1 to n do		{��ȡ���λ�ã���Դ�������ǵ��������}
    begin
      read(x,y);
      c[0]^[(x-1)*b+y]:=1;
    end;
  for i:=1 to n do		{��ȡ����λ�ã������ǵĳ�����������}
    begin
      read(x,y);
      c[(x-1)*b+y+a*b]^[2*a*b+1]:=1;
    end;
  close(input);
end;
procedure solve;		{��������С����������㷨}
var   i,j,k,u,x   :    integer;
      count,mind  :    integer;
      d,p         :    array [0..MAXN*MAXN*2+1] of integer;
      mark        :    array [0..MAXN*MAXN*2+1] of boolean;
begin
  repeat
    for i:=0 to v do		{�����Է���ΪȨ��ͼ}
      for j:=0 to v do
        if c[i]^[j]>0 then
          begin
            if f[i]^[j]<c[i]^[j] then g[i]^[j]:=w[i]^[j]
              else g[i]^[j]:=maxint;
            if f[i]^[j]>0 then g[j]^[i]:=-w[i]^[j]
              else g[j]^[i]:=maxint;
          end
          else
            if c[j]^[i]=0 then
              begin
                g[i]^[j]:=maxint;
                g[j]^[i]:=maxint;
              end;
    for i:=1 to v do
      begin
        d[i]:=maxint;
        mark[i]:=true;
      end;
    d[0]:=0;			{������������ͼ�У�Դ�����������·��}
    k:=0;
    repeat
      mark[k]:=false;
      for i:=1 to v do
        if (g[k]^[i]<maxint)and(d[i]>d[k]+g[k]^[i]) then
          begin
            d[i]:=d[k]+g[k]^[i];
            p[i]:=k;
            mark[i]:=true;
          end;
      mind:=maxint;k:=-1;
      for i:=1 to v do
        if (mark[i])and(d[i]<mind) then
          begin
            k:=i;
            mind:=d[k];
          end;
    until k<0;
    if d[v]=maxint then break;
    u:=v;					{����������е���С����}					
    x:=maxint;
    while u>0 do
      begin
        if c[p[u]]^[u]>0 then
          begin
            if x>c[p[u]]^[u]-f[p[u]]^[u] then x:=c[p[u]]^[u]-f[p[u]]^[u];
          end
          else
            if x>f[u]^[p[u]] then x:=f[u]^[p[u]];
        u:=p[u];
      end;
    u:=v;					{�Ľ�������}
    while u>0 do
      begin
        if c[p[u]]^[u]>0 then f[p[u]]^[u]:=f[p[u]]^[u]+x
          else f[u]^[p[u]]:=f[u]^[p[u]]-x;
        u:=p[u];
      end;
  until false;
  count:=0;
  for i:=0 to v-1 do
    if f[i]^[v]>0 then count:=count+f[i]^[v];	{����������������}
  assign(output,outputfile);
  rewrite(output);
  if count=n then			{�������������������N���н⣬�����޽�}
    begin
      count:=0;
      for i:=0 to v do
        for j:=0 to v do count:=count+f[i]^[j]*w[i]^[j];
      writeln(count);			{�н�����£�����ܷ���}
    end
    else writeln(-1);
  close(output);
end;
begin
  initialize;		{�������ݣ���ͼ}
  solve;		{��������С����������㷨}
end.