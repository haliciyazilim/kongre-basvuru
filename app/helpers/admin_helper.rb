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
    if applicant.applicant_category == 'instructor_student'
      'Öğretmen / Öğrenci'
    elsif applicant.applicant_category == 'civillian'
      'Sivil Katılım'
    else
      ''
    end
  end

  def previous_attendances(applicant)
    result = ''
    previous_attendances = applicant.previous_attendances.to_i
    result += '2013 Kongresine katılmış' if  previous_attendances & 1
    result += (result.length>0?' – ':'') + '2014 Kongresine katılmış' if previous_attendances & 2
    result += (result.length>0?' – ':'') + 'İlk kez katılıyor' if previous_attendances & 4
    result
  end

end
