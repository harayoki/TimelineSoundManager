package net.harayoki.sound
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;

	public class TimelineSoundManager
	{
		
		private var _soundInfo:Object;
		private var _enabled:Boolean = true;
		
		public function TimelineSoundManager()
		{
			_soundInfo  = {};
		}
		
		/**
		 * タイムラインにイベントサウンドが仕込まれたMovieClipを与えます
		 */
		public function applyClip(clip:MovieClip,volume:Number=1.0):void
		{
			var scene:Scene = clip.scenes[0];
			var frames:Vector.<FrameLabel> = Vector.<FrameLabel>(scene.labels);
			for(var i:int=0;i<frames.length;i++)
			{
				var id:String = frames[i].name;
				_soundInfo[id] = new Info(clip,id);
			}			
			clip.soundTransform = new SoundTransform(volume);
		}
		
		/**
		 * サウンドが再生可能か確認します
		 */
		public function hasSoundData(id:String):Boolean
		{
			return _soundInfo[id] ? true : false;
		}
		
		/**
		 * マネージャを有効にします
		 */
		public function setEnabled(b:Boolean):void
		{
			_enabled = b;			
		}
		
		/**
		 * マネージャが有効か調べます
		 */
		public function isEnabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * SEを再生します
		 */
		public function playSe(id:String):void
		{
			if(!_enabled) return;
			var info:Info = _soundInfo[id] as Info;
			if(!info) return;
			if(getTimer() - info.lastPlayed < info.noPlayWithin) return;
			info.clip.gotoAndStop(info.id);
			info.clip.gotoAndStop(1);
			info.lastPlayed = getTimer();
		}

		
	}
}
import flash.display.MovieClip;

internal class Info
{
	public var clip:MovieClip;
	public var id:String;
	public var volume:Number = 1.0;
	public var lastPlayed:Number = 0;
	public var noPlayWithin:Number = 50;
	public function Info(clip:MovieClip,id:String,volume:Number=1.0)
	{
		this.clip = clip;
		this.id = id;
		this.volume = volume;
	}
	
}