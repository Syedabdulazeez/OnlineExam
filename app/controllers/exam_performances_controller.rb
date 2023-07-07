# app/controllers/exam_performances_controller.rb
class ExamPerformancesController < ApplicationController
  def show
    @exam_performance = ExamPerformance.find(params[:id])
  end
  def generate_report
    @exam_performance = ExamPerformance.find(params[:id])

    # Generate the performance report PDF using Prawn
    pdf = Prawn::Document.new
    generate_performance_report(pdf, @exam_performance)

    # Save the PDF temporarily on the server
    pdf_temp_file = Tempfile.new(["performance_report", ".pdf"], "tmp")
    pdf_temp_file.binmode
    pdf_temp_file.write(pdf.render)
    pdf_temp_file.rewind

    # Send the report via email using Action Mailer
    PerformanceReportMailer.send_report(@exam_performance, pdf_temp_file).deliver_now

    # Close and delete the temporary file
    pdf_temp_file.close
    pdf_temp_file.unlink

    # Redirect or display success message
    flash[:notice] = "Performance report generated and sent successfully."
    redirect_to leaderboard_index_path(@exam_performance.user)
  end

  private

  def generate_performance_report(pdf, exam_performance)
    # Custom logic to generate the performance report using Prawn
    # Modify this according to your specific report layout and content
    pdf.text "Performance Report", size: 18, style: :bold, align: :center
    pdf.move_down 20
    pdf.text "Candidate Name: #{exam_performance.user.username}"
    pdf.text "Exam Date: #{}"
    pdf.text "Score: #{exam_performance.marks_obtained}"
    # Add more content and formatting as needed
  end
end
