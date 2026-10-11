/*==============================================================================
  项目：子女数量对家庭资产配置的影响
  说明：包含 LPM、Probit、Tobit 估计，导出 Word 表格及画图
==============================================================================*/

// -----------------------------------------------------------------------------
// 第一步：环境清理与路径设置
// -----------------------------------------------------------------------------
clear all
set more off

cd "/Users/jiahaotian/Desktop/北大作业"
use "最终合并数据集.dta", clear

// -----------------------------------------------------------------------------
// 第二步：异常值清洗与变量生成
// -----------------------------------------------------------------------------

// 1. 清理 CFPS 负数异常值 (-1, -2, -8, -9 等)
mvdecode _all, mv(-999/-1)

// 2. 核心解释变量：未成年子女数量
cap drop child_num
gen child_num = child16n
label variable child_num "未成年子女数量"

// 3. 被解释变量 1：是否持有风险资产 (0 或 1)
cap drop risk_dummy
gen risk_dummy = 0
replace risk_dummy = 1 if financial_product > 0 & financial_product != .
label variable risk_dummy "是否持有风险资产"

// 4. 被解释变量 2：风险资产占总金融资产比重 (0 ~ 1 之间)
cap drop risk_share
gen risk_share = financial_product / finance_asset
replace risk_share = 0 if financial_product == 0
label variable risk_share "风险资产占总金融资产比重"

// 5. 控制变量构建
cap drop married
gen married = (qea0 >= 2 & qea0 <= 3) if !missing(qea0)
label variable married "是否婚姻(1=是,0=否)"

cap drop log_income
gen log_income = log(fincome1 + 1)
label variable log_income "家庭总收入对数"

label variable age "户主年龄"

// -----------------------------------------------------------------------------
// 第三步：基准回归分析
// -----------------------------------------------------------------------------

// 【模型 1】线性概率模型 (LPM)
regress risk_dummy child_num age married log_income, vce(robust)
est store Model_LPM

// 【模型 2】Probit 模型
probit risk_dummy child_num age married log_income if log_income > 0, vce(robust)
est store Model_Probit

// 【模型 3】Tobit 模型
tobit risk_share child_num age married log_income, ll(0) vce(robust)
est store Model_Tobit

// -----------------------------------------------------------------------------
// 第四步：导出全部回归结果到 RTF/Word 文档 (使用 esttab 解决乱码与表头堆叠)
// -----------------------------------------------------------------------------

// 1. 设置变量的中文显示名称
label variable child_num "未成年子女数量"
label variable age "户主年龄"
label variable married "婚姻状况(1=已婚)"
label variable log_income "家庭总收入对数"

// 2. 使用 esttab 导出规范的三线表 Word 文档
esttab Model_LPM Model_Probit Model_Tobit using "基准回归结果汇总.rtf", replace ///
    mtitle("LPM" "Probit" "Tobit") ///   // 给 (1)(2)(3) 独自分配唯一的标题
    b(%6.4f) t(%6.3f) ///                 // 保留 4 位小数，括号内显示 t/z 统计量
    star(* 0.1 ** 0.05 *** 0.01) ///      // 显著性标注
    label ///                             // 使用中文变量标签
    title("表1 子女数量对家庭资产配置的影响") ///
    addnotes("注：括号内为异方差稳健 t 统计量；* p<0.1, ** p<0.05, *** p<0.01")

// -----------------------------------------------------------------------------
// 第五步：绘制并导出资产分布柱状图
// -----------------------------------------------------------------------------

// 图 1：不同未成年子女数量下的家庭风险资产参与率
graph bar (mean) risk_dummy, over(child_num) ///
    title("不同子女数量家庭的风险资产参与率") ///
    ytitle("参与率 (持有风险资产家庭比例)") ///
    blabel(bar, format(%4.3f)) ///
    graphregion(color(white))

graph export "不同子女数量风险资产参与率.png", replace width(2000)

// 图 2：不同未成年子女数量下的家庭风险资产平均占比
graph bar (mean) risk_share, over(child_num) ///
    title("不同子女数量家庭的风险资产平均配置占比") ///
    ytitle("风险资产占总金融资产比重") ///
    blabel(bar, format(%4.3f)) ///
    graphregion(color(white))

graph export "不同子女数量风险资产占比.png", replace width(2000)
