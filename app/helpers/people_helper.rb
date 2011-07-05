module PeopleHelper
  def link_to_person(person, options={})
    link_to(person.display_name, person, options).html_safe
  end

  def pretty_print(people, options={})
    separator = options.delete(:separator) || ", "
    with_links = options.delete(:with_links)
    with_links = true if with_links.nil?

    if people.is_a? Person
      with_links ? link_to_person(people, options).html_safe : people.display_name
    else
      with_links ? people.collect { |p| link_to_person(p, options) }.join(separator).html_safe : people.collect(&:display_name).join(separator)
    end
  end
end
