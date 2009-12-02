{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,655360}
Uses D1;
Var
  Map:Array[1..100,1..100]Of Byte;{�洢����}
  M,N:Byte;
(*******��ȡ�ӵ�i1�е���i2�У��ӵ�j1�е���j2�о��η�Χ�ڵ����о���Ԫ��*******)
Procedure Get(i1,j1,i2,j2:Byte;Count:Integer);
Var
  i,j,k,l:Integer;
Begin
  If Count=0 Then{���������ȫΪ0}
    Begin
      For i:=i1 to i2 Do
        For j:=j1 to j2 Do
          Map[i,j]:=0;
    End
    Else If Count=(i2-i1+1)*(j2-j1+1) Then{���������ȫΪ1}
      Begin
        For i:=i1 to i2 Do
          For j:=j1 to j2 Do
            Map[i,j]:=1;
      End
      Else Begin
        k:=Random(2);{��������ָ��}
        If ((k=0)And(i1<i2))Or(j1>=j2) Then{����ָ�}
          Begin
            k:=(i1+i2)Div 2;
            l:=Detect(i1,j1,k,j2);
            Get(i1,j1,k,j2,l);
            Get(k+1,j1,i2,j2,Count-l);
          End
          Else Begin{����ָ�}
            k:=(j1+j2)Div 2;
            l:=Detect(i1,j1,i2,k);
            Get(i1,j1,i2,k,l);
            Get(i1,k+1,i2,j2,Count-l);
          End;
      End;
End;
(*******�����*******)
Procedure Print;
Var
  i,j:Byte;
Begin
  For i:=1 to M Do
    Begin
      For j:=1 to N Do
        Write(Map[i,j]);
      WriteLn;
    End;
End;
Begin
  Start;
  Assign(Input,'dragon1.in');
  Reset(Input);
  Assign(Output,'dragon1.out');
  Rewrite(Output);
  Randomize;
  ReadLn(M,N);
  Get(1,1,M,N,Detect(1,1,M,N));
  Print;
  Close(Output);
  Close(Input);
  Finish;
End.