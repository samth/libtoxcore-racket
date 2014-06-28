#lang scribble/doc
@(require "common.rkt")

@title[#:tag "av"]{Audio/Video}

@defmodule[libtoxcore-racket/av]

The functions in @racketmodname[libtoxcore-racket/av] pertain to Audio/Video interaction.

@section[#:tag "structs"]{Structs}

@defstruct[_ToxAvCallback ([num integer?] [arg cpointer?])]{
  A cstruct for the callback functions.
}

@defstruct[_ToxAvCodecSettings ([video_bitrate integer?]
                                [video_width integer?]
                                [video_height integer?]
                                [audio_bitrate integer?]
                                [audio_frame_duration integer?]
                                [audio_sample_rate integer?]
                                [audio_channels integer?]
                                [audio_VAD_tolerance integer?]
                                [jbuf_capacity integer?])]{
  @racket[video_bitrate] is in kbit/s
  
  @racket[video_width] is in px
  
  @racket[video_height] is in px
  
  @racket[audio_bitrate] is in bits/s
  
  @racket[audio_frame_duration] is in ms
  
  @racket[audio_sample_rate] is in Hz
  
  @racket[audio_VAD_tolerance] is in ms
}

@section[#:tag "procedures"]{Procedures}

@defproc[(av-new [messenger _Tox-pointer] [max_calls integer?]) _ToxAv-pointer]{
  Start new A/V session. There can only be one session at the time.
  If you register more it will result in undefined behaviour.
  
  return @racket[_ToxAv-pointer]
  
  return NULL On error.
}

@defproc[(av-kill! [av _ToxAv-pointer]) void?]{
  Remove A/V session.
  
  return void
}

@defproc[(register-callstate-callback [callback _ToxAVCallback-pointer]
                                      [id integer?] [userdata pointer?]) void?]{
  Register callback for call state.
 
  @racket[callback] is the callback
  
  @racket[id] is one of the @racket[ToxAvCallbackID] values
  
  return void
}

@defproc[(av-call [av _ToxAv-pointer]
                  [call-index cpointer?]
                  [user integer?]
                  [call-type integer?]
                  [ringing-seconds integer?]) integer?]{
  Call user. Use its friend_id.
 
  @racket[user] is the user.
  
  @racket[call-type] is the call type, an enum value
  
  @racket[ringing-seconds] is the ringing timeout.
  
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(av-hangup [av  _ToxAv-pointer]
                    [call-index integer?]) integer?]{
  Hangup active call.
 
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(av-answer [av _ToxAv-pointer]
                    [call-index integer?]
                    [call-type integer?]) integer?]{
  Answer incoming call.
 
  return 0 on success.
  
  return @racket[ToxAvError] On error.
}

@defproc[(av-reject [av _ToxAv-pointer]
                 [call-index integer?]
                 [reason string?]) integer?]{
  Reject incoming call.
 
  Optional reason. Set NULL if none.
  
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(av-cancel [av _ToxAv-pointer]
                    [call-index integer?]
                           [peer-id integer?]
                           [reason string?]) integer?]{
  Cancel outgoing request.
  
  Optional reason.
  
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(av-stop-call [av _ToxAv-pointer]
                       [call-index integer?]) integer?]{
  Terminate transmission. Note that transmission will be terminated without
  informing remote peer.
 
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(prepare-transmission [av _ToxAv-pointer]
                               [call-index integer?]
                               [codec-settings cpointer?]
                               [support-video? boolean?]) integer?]{
  Must be called before any RTP transmission occurs.
  
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(kill-transmission [av _ToxAv-pointer]
                            [call-index integer?]) integer?]{
  Call this at the end of the transmission.
  
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(recv-video [av _ToxAv-pointer]
                     [call-index integer?]
                     [output cpointer?]) integer?]{
  Receive decoded video packet.
  
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(recv-audio [av _ToxAv-pointer]
                     [call-index integer?]
                            [frame-size integer?]
                            [dest cpointer?]) integer?]{
  Receive decoded audio frame.
 
  @racket[frame-size] is the size of dest in frames/samples
  (one frame/sample is 16 bits or 2 bytes and corresponds to one sample of audio.)
  
  @racket[dest] is the destination of the raw audio (16 bit signed pcm with
  AUDIO_CHANNELS channels). Make sure it has enough space for @racket[frame-size]
  frames/samples.
  
  return >=0 size of received data in frames/samples.
  
  return @racket[ToxAvError] on error.
}

@defproc[(send-video [av _ToxAv-pointer]
                     [call-index integer?]
                     [frame cpointer?]
                     [frame-size integer?]) integer?]{
  Encode and send video packet.
  
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(send-audio [av _ToxAv-pointer]
                     [call-index inteder?]
                     [frame cpointer?]
                     [frame-size integer?]) integer?]{
  Send audio frame.
  
  @racket[frame] is the frame (raw 16 bit signed pcm with AUDIO_CHANNELS channels audio.)
  
  @racket[frame-size] is its size in number of frames/samples (one frame/sample is 16
  bits or 2 bytes). @racket[frame-size] should be AUDIO_FRAME_SIZE.
  
  return 0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(prepare-video-frame [av _ToxAv-pointer]
                              [call-index integer?]
                              [dest cpointer?]
                              [dest-max integer?]
                              [input cpointer?]) integer?]{
  Encode video frame.
  
  return >0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(prepare-audio-frame [av _ToxAv-pointer]
                              [call-index integer?]
                              [dest cpointer?]
                              [dest-max integer?]
                              [frame cpointer?]
                              [frame-size integer?]) integer?]{
  Encode audio frame.
  
  return >0 on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(get-peer-transmission-type [av _ToxAv-pointer]
                                     [call-index integer?]
                                     [peer integer?]) integer?]{
  Get peer transmission type. It can either be audio or video.
 
  return @racket[ToxAvCallType] on success.
  
  return @racket[ToxAvError] on error.
}

@defproc[(get-peer-id [av _ToxAv-pointer]
                      [call-index integer?]
                      [peer integer?]) integer?]{
  Get id of peer participating in conversation
  
  return @racket[ToxAvError] when there is no peer id
}

@defproc[(capability-supported? [av _ToxAv-pointer]
                                [call-index integer?]
                                [capability integer?]) boolean?]{
  Is a certain capability supported?
  
  @racket[capability] is on of @racket[ToxAvCapabilities].
}

@defproc[(set-audio-queue-limit [av _ToxAv-pointer]
                                [call-index integer?]
                                [limit integer?]) integer?]{
  Set queue limit.
}

@defproc[(set-video-queue-limit [av _ToxAv-pointer]
                                [call-index integer?]
                                [limit integer?]) integer?]{
  Set queue limit.
}

@defproc[(av-get-tox [av _ToxAv-pointer]) _Tox-pointer]{
  Return the @racket[_Tox-pointer] being used with the @racket[_ToxAv-pointer].
}

@defproc[(av-has-activity? [av _ToxAv-pointer]
                           [call-index integer?]
                           [pcm cpointer?]
                           [frame-size integer]
                           [ref-energy inexact?]) boolean?]{
  Return whether or not there is A/V activity.
}
