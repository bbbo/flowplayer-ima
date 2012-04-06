/*
 *	Copyright (c) 2011 Andrew Stone
 *	This file is part of flowplayer-ima.
 *
 *	flowplayer-streamtheworld is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	flowplayer-streamtheworld is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with flowplayer-streamtheworld.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.iheart.ima {
	import org.flowplayer.controller.StreamProvider;
	import org.flowplayer.controller.TimeProvider;
	import org.flowplayer.model.Clip;
	import org.flowplayer.model.ClipEvent;
	import org.flowplayer.model.Playlist;
	import org.flowplayer.model.Plugin;
	import org.flowplayer.model.PluginModel;
	import org.flowplayer.util.Log;
	import org.flowplayer.util.PropertyBinder;
	import org.flowplayer.view.Flowplayer;
	import org.flowplayer.controller.VolumeController;
	
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class InteractiveMediaAdsProvider implements Plugin, StreamProvider {
		private var log:Log = new Log(this);
		
		private var _config:Config;
		private var _model:PluginModel;
		private var _player:Flowplayer;
		
		private var _playlist:Playlist;
		
		private var _activeAd:AdPlayer;
		
		/**
		 * Plugin Methods
		 * -----------------------------------------------------------------------------------------
		 */
		
		public function getDefaultConfig():Object {
			return null;
		}
		
		public function onConfig(model:PluginModel):void {
			_model = model;
			_config = new PropertyBinder(new Config()).copyProperties(model.config) as Config;
			_model.dispatchOnLoad();
		}
		
		public function onLoad(player:Flowplayer):void {
			_player = player;
		}
		
		/**
		 * StreamProvider methods
		 * -----------------------------------------------------------------------------------------
		 */
		
		public function load(event:ClipEvent, clip:Clip, pauseAfterStart:Boolean = true):void {
			_activeAd = new AdPlayer(_player, _config, _model, clip);
		}
		
		public function getVideo(clip:Clip):DisplayObject {
			//we clean up after ourselves
			return null;
		}
		
		public function pause(event:ClipEvent):void {
		
		}
		
		public function resume(event:ClipEvent):void {
		
		}
		
		public function stop(event:ClipEvent, closeStream:Boolean = false):void {
		
		}
		
		public function get time():Number {
			return _activeAd ? _activeAd.time : 0;
		}
		
		public function set volumeController(controller:VolumeController):void {
			if (_activeAd) {
				_activeAd.volumeController = controller;
			}
		}
		
		public function stopBuffering():void {
		
		}
		
		public function set playlist(playlist:Playlist):void {
			_playlist = playlist;
		}

		public function get playlist():Playlist {
			return _playlist;
		}
		
		public function get type():String {
			return 'ad';
		}
		
		/**
		 * Things that we just don't use.  Most of these can be ignored safely (I think) -- at
		 * least they are in the AudioProvider plugin
		 */
		 
		public function get stopping():Boolean {
			return false;
		}
		 
		public function switchStream(event:ClipEvent, clip:Clip, netStreamPlayOptions:Object = null):void {
			log.info('switching streams');
		}
		
		public function seek(event:ClipEvent, seconds:Number):void {}
		
		public function get allowRandomSeek():Boolean {
			return false;
		}
		
		public function get netStream():NetStream {
			return null;
		}
		
		public function get netConnection():NetConnection {
			return null;
		}
		
		public function attachStream(video:DisplayObject):void {}
		
		public function addConnectionCallback(name:String, listener:Function):void {}
		
		public function addStreamCallback(name:String, listener:Function):void {}
		
		public function get streamCallbacks():Dictionary {
			return null;
		}
		
		/**
		 * Can't get these from the IMA SDK
		 */
		public function get bufferStart():Number {
			return 0;
		}
		
		public function get bufferEnd():Number {
			return 0;
		}
		
		public function get fileSize():Number {
			return 0;
		}
		
		public function set timeProvider(timeProvider:TimeProvider):void {
			log.error('Attempted to set time provider');
		}
		
		/**
		 * Javascript Methods
		 * -----------------------------------------------------------------------------------------
		 */
		
		[External]
		public function playAd(url:String):void {
			_player.play(_player.config.createClip({
				'provider': 'ima',
				'url': url
			}));
		}
		
		/**
		 * Private Methods
		 * -----------------------------------------------------------------------------------------
		 */
		
		/*
		private function _resize():void {
			width = stage.width;
			height = stage.height;
			
			//draw a black background
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, stage.width, stage.height);
			graphics.endFill();
		}
		//*/
	}
}