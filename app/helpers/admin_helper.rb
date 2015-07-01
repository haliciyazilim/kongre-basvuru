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
    else
      'Katılımcı'
    end
  end
end
