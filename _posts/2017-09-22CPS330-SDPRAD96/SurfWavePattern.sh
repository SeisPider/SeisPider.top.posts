#!/bin/sh
# 计算在特定模型和频率下，面波特征值随深度变化的函数
## 指定将计算的周期
PER1=10
PER2=20
PER3=40
cat > perfil << EOF
$PER1
$PER2
$PER3
EOF
## 指定震源深度
HS=2
## 指定台站深度
HR=0
## 为计算面波频散特征值作准备，包括指定面波类型 Love(-L), Rayl(-R) 、以 perfil 文
## 件指定周期 和 将要计算的面波模态数目 (1 表示仅计算基阶面波)
sprep96 -M modcus.d -HS $HS -HR $HR -L -R -PARR perfil -NMOD 1
## 利用给定的 modcus.d 模型计算面波频散
sdisp96 -v
## 计算 Rayl 和 Love 特征值随深度的函数
sregn96 -DER
slegn96 -DER


# 计算和绘制理论辐射花样 
## 定义震源信息
MOM=1.0e+22
DIP=70
RAKE=70
STK=20

## 定义参考距离和面波模态
DIST=1000
MODE=0
## 对于不同周期进行循环
for FIG in 01 02 03
do
case ${FIG} in
	01) PER=$PER1 ; X0=2.0 ; Y0=6.0;;
	02) PER=$PER2 ; X0=5.0 ; Y0=6.0;;
	03) PER=$PER3 ; X0=8.0 ; Y0=6.0;;
esac
sdprad96 -R -DIP ${DIP} -RAKE ${RAKE} -STK ${STK} -DIST ${DIST} \
	        -PER ${PER} -HS ${HS} -M ${MODE} -M0 ${MOM} -X0 ${X0} \
		    -Y0 ${Y0} 
mv SRADR.PLT R${FIG}.PLT
done
for FIG in 04 05 06
do
case ${FIG} in
	04) PER=$PER1 ; X0=2.0 ; Y0=2.0;;
	05) PER=$PER2 ; X0=5.0 ; Y0=2.0;;
	06) PER=$PER3 ; X0=8.0 ; Y0=2.0;;
esac
sdprad96 -L -DIP ${DIP} -RAKE ${RAKE} -STK ${STK} -DIST ${DIST} \
	        -PER ${PER} -HS ${HS} -M ${MODE} -M0 ${MOM} \
			-X0 ${X0} -Y0 ${Y0} 
mv SRADL.PLT L${FIG}.PLT
done
## 将各子图粘连在一起
cat L??.PLT R??.PLT CALPLT.PLT > SRAD.PLT
## 移除垃圾文件
rm -f CALPLT.PLT CALPLT.cmd L??.PLT R??.PLT

## 绘制成图
plotxvig < SRAD.PLT
