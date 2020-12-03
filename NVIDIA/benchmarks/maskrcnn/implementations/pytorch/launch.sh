#!/bin/bash
BASE_LR=0.008
MAX_ITER=25000
WARMUP_FACTOR=0.0001
WARMUP_ITERS=100
TRAIN_IMS_PER_BATCH=64
TEST_IMS_PER_BATCH=64
WEIGHT_DECAY=5e-4
NSOCKETS_PER_NODE=2
NCORES_PER_SOCKET=24
NPROC_PER_NODE=8
OPTIMIZER="NovoGrad"
LR_SCHEDULE="COSINE"
BETA1=0.9
BETA2=0.4
LS=0.1
FPN_POST_NMS_TOP_N_TRAIN=1000

/shared/mzanur/conda_pt/bin/python -u -m bind_launch --nnodes 1 --node_rank 0 --master_addr 127.0.0.1 --master_port 1234 --nsockets_per_node=${NSOCKETS_PER_NODE} \
 --ncores_per_socket=${NCORES_PER_SOCKET} --nproc_per_node=${NPROC_PER_NODE} \
 tools/train_mlperf.py --config-file 'configs/e2e_mask_rcnn_R_50_FPN_1x.yaml' \
 DTYPE 'float16' \
 PATHS_CATALOG 'maskrcnn_benchmark/config/paths_catalog_dbcluster.py' \
 DISABLE_REDUCED_LOGGING True \
 SOLVER.BASE_LR ${BASE_LR} \
 SOLVER.WEIGHT_DECAY ${WEIGHT_DECAY} \
 SOLVER.MAX_ITER ${MAX_ITER} \
 SOLVER.WARMUP_FACTOR ${WARMUP_FACTOR} \
 SOLVER.WARMUP_ITERS ${WARMUP_ITERS} \
 SOLVER.WEIGHT_DECAY_BIAS 0 \
 SOLVER.WARMUP_METHOD mlperf_linear \
 SOLVER.IMS_PER_BATCH ${TRAIN_IMS_PER_BATCH} \
 SOLVER.OPTIMIZER ${OPTIMIZER} \
 SOLVER.BETA1 ${BETA1} \
 SOLVER.BETA2 ${BETA2} \
 MODEL.RPN.LS ${LS} \
 MODEL.ROI_HEADS.LS ${LS} \
 SOLVER.LR_SCHEDULE ${LR_SCHEDULE} \
 TEST.IMS_PER_BATCH ${TEST_IMS_PER_BATCH} \
 MODEL.RPN.FPN_POST_NMS_TOP_N_TRAIN ${FPN_POST_NMS_TOP_N_TRAIN} \
 NHWC True

