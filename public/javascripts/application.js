// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var restripe = function(selector){
  var to_restripe = $(selector+':not(.remove)');
  for(var i = 0; i < to_restripe.length; i++ ){
    if( i % 2 == 0){
      $(to_restripe[i]).removeClass('odd').addClass('even');
    } else {
      $(to_restripe[i]).removeClass('even').addClass('odd');
    }
  }
};

$(function(){
  $('.toggle').click(function(){
    var to_toggle = $(this).attr('id');
    $('.project.'+to_toggle).toggleClass('remove');
    restripe('.project');
    $(this).find('.check').toggleClass('remove');
    $(this).find('.text').toggleClass('remove');
  });

  $('.flash .close').click(function(){
    var self = $(this).parent().parent();
    self.slideUp( function(){ self.remove() });
  });

  $('.add_project_button').click(function(){
    var self = $(this);
    self.addClass('hidden');
    var project = self.parents('.freckle_project');
    project.find('input').removeAttr('disabled');
    project.find('.added').removeClass('hidden');
    project.find('input.delete').attr('disabled', 'disabled').val('false');
  });
  $('.cancel_project_button').click(function(){
    var self = $(this);
    var project = self.parents('.freckle_project');
    project.find('.add_project_button').removeClass('hidden');
    project.find('.added').addClass('hidden');
    project.find('input').attr('disabled', 'disabled');
  });
  $('.delete_project_button').click(function(){
    var self = $(this);
    var project = self.parents('.freckle_project');
    project.find('.add_project_button').removeClass('hidden');
    project.find('.added').addClass('hidden');
    project.find('input').attr('disabled', 'disabled');
    project.find('input.delete').removeAttr('disabled').val('true');
  });

  
});
