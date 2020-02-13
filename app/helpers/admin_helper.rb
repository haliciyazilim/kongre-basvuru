module AdminHelper
  def relation_to_high_intelligence(applicant)
    text = applicant.relation_to_high_intelligence
    if text == 'high_intelligent'
      'Üstün zekâlı'
    elsif text == 'high_intelligent_relative'
      'Ailede üstün zekâlı'
    elsif text == 'educator'
      'Eğitimci / Araştırmacı'
    elsif text == 'psychologist'
      'Psikolog / Psikiyatrist'
    elsif text == 'none'
      'Yok'
    else
      text
    end
  end

  def applicant_type(applicant)
    if applicant.applicant_type == 'presenter'
      'Konuşmacı'
    elsif applicant.applicant_type == 'attandee'
      'Katılımcı'
    else
      ''
    end
  end

  def applicant_category(applicant)
    if applicant.applicant_category == ApplicantCategory.instructor_student
      'Öğretmen / Öğrenci'
    elsif applicant.applicant_category == ApplicantCategory.civillian
      'Sivil Katılım'
    elsif applicant.applicant_category == ApplicantCategory.child
      'Çocuk'
    else
      ''
    end
  end

  def previous_attendances(applicant)
    result = ''
    previous_attendances = applicant.previous_attendances.to_i
    result += 'İlk kez katılıyor' if  previous_attendances == 0 
    result += 'Daha önce katılmış' if  previous_attendances == 1 
    # result += (result.length>0?' – ':'') + '2013 Kongresine katılmış' if previous_attendances & 2 != 0
    # result += (result.length>0?' – ':'') + '2014 Kongresine katılmış' if previous_attendances & 4 != 0
    # result += (result.length>0?' – ':'') + '2015 Kongresine katılmış' if previous_attendances & 8 != 0
    result
  end

end
