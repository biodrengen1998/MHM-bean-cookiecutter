import sys

sys.path.append('/projects/cpr_nilsson/people/gbp326/programs/crispr-bean/bin')


import bean as be
import argparse


def analyze_bean_data(working_dir,screen_id, output_dir, control_condition="D0"):
    """
    Analyzes bean data using the bean library and saves results.

    Args:
        screen_id: Name of the screen to be analyzed (replaces "Emil_test_run").
        output_dir: Directory to save results (replaces "toy_output").
        control_condition: Name of the control condition (replaces "D0").
    """

    # Read data
    bdata = be.read_h5ad(f"{working_dir}/{output_dir}/bean_count_{screen_id}.h5ad")


    bdata.uns['allele_counts'] = bdata.uns['allele_counts'].loc[bdata.uns['allele_counts'].allele.map(str) != ""]
    bdata.get_edit_from_allele()
    bdata.get_edit_mat_from_uns(
    )
    bdata.get_guide_edit_rate(
        normalize_by_editable_base=False,
        condition_col="condition",
        unsorted_condition_label=control_condition,
)

    # Save results
    bdata.to_Excel(f"{working_dir}/{output_dir}/bean_count_{screen_id}_wedits.xlsx")
    bdata.write(f"{working_dir}/{output_dir}/bean_count_{screen_id}_wedits.h5ad")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Analyze bean data.")
    parser.add_argument("working_dir", help="Directory containing data")
    parser.add_argument("screen_id", help="Name of the screen to be analyzed")
    parser.add_argument("output_dir", help="Directory to save results")
    parser.add_argument("-c", "--control_condition", default="D0", help="Name of the control condition")
    args = parser.parse_args()

    analyze_bean_data(args.working_dir, args.screen_id, args.output_dir, args.control_condition)