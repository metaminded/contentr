module Contentr
  module Admin
    class ContentBlocksController < Contentr::Admin::ApplicationController
      PERMITTED_PARAMS = [:name, :partial]

      layout 'application'

      prepend PrependedContentBlocksControllerExtension

      def index
        tabulatr_for Contentr::ContentBlock
      end

      def new
        @content_block = Contentr::ContentBlock.new
      end

      def create
        @content_block = Contentr::ContentBlock.new(content_block_params)
        if @content_block.save
          redirect_to contentr.admin_content_blocks_path, notice: t('.success')
        else
          render action: :new
        end
      end

      def edit
        @content_block = Contentr::ContentBlock.find(params[:id])
      end

      def update
        @content_block = Contentr::ContentBlock.find(params[:id])
        if @content_block.update(content_block_params)
          redirect_to contentr.admin_content_blocks_path, notice: t('.success')
        else
          render :action => :edit
        end
      end

      def destroy
        @content_block = Contentr::ContentBlock.find(params[:id])
        if @content_block.usages.none?
          @content_block.destroy
          redirect_to contentr.admin_content_blocks_path, notice: t('.success')
        else
          redirect_to contentr.admin_content_blocks_path, alert: t('.failure')
        end
      end

      private

      def content_block_params
        params.require(:content_block).permit(PERMITTED_PARAMS)
      end
    end
  end
end
